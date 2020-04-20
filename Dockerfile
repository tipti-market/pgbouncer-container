FROM registry.access.redhat.com/ubi7/ubi-minimal

RUN curl -sLO https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm -ivh epel-release-latest-7.noarch.rpm && \
    rm epel-release-latest-7.noarch.rpm && \
    microdnf -y update && \
    microdnf -y --enablerepo=epel-testing install pgbouncer && \
    microdnf clean all

RUN chown pgbouncer:0 /etc/pgbouncer && \
    chmod g=u /etc/pgbouncer && \
    rm /etc/pgbouncer/pgbouncer.ini

ADD entrypoint.sh /entrypoint.sh
EXPOSE 5432
USER pgbouncer

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
