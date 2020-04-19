# Build PgBouncer
FROM centos:7 AS build

RUN yum -y update && \
    yum -y install c-ares-devel gcc libevent-devel make openssl-devel && \
    yum clean all

WORKDIR /tmp/pgbouncer

ENV PGBOUNCER_VERSION=1.12.0
RUN curl -sLO https://www.pgbouncer.org/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz
RUN tar xzf pgbouncer-${PGBOUNCER_VERSION}.tar.gz --strip-components=1
RUN ./configure --prefix=/usr
RUN make && make install

# Run PgBouncer
FROM centos:7

RUN yum -y update && \
    yum -y install c-ares libevent openssl && \
    yum clean all

COPY --from=build /usr/bin/pgbouncer /usr/bin/pgbouncer

RUN groupadd -r pgbouncer && \
    useradd -r -g pgbouncer -M -d / -s /sbin/nologin -c "PgBouncer Server" pgbouncer && \
    mkdir /etc/pgbouncer && \
    chown pgbouncer:0 /etc/pgbouncer && \
    chmod g+rw /etc/pgbouncer

EXPOSE 5432
USER pgbouncer
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
