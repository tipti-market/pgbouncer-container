FROM centos:7 AS build

RUN yum -y update && \
    yum -y install gcc libevent-devel make openssl-devel pam-devel && \
    yum clean all

WORKDIR /tmp/pgbouncer

ENV PGBOUNCER_VERSION=1.12.0
RUN curl -sLO https://www.pgbouncer.org/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz
RUN tar xzf pgbouncer-${PGBOUNCER_VERSION}.tar.gz --strip-components=1
RUN ./configure --prefix=/usr --with-pam
RUN make && make install

FROM centos:7

RUN yum -y update && \
    yum -y install libevent openssl pam && \
    yum clean all

RUN groupadd -r pgbouncer && useradd -r -s /sbin/nologin -d / -M -c "PgBouncer Server" -g pgbouncer pgbouncer

COPY --from=build /usr/bin/pgbouncer /usr/bin/pgbouncer
RUN chown pgbouncer /usr/bin/pgbouncer

RUN mkdir /etc/pgbouncer && \
    chown -R pgbouncer /etc/pgbouncer 

ADD entrypoint.sh /entrypoint.sh
USER pgbouncer
EXPOSE 5432
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
