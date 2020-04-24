FROM registry.access.redhat.com/ubi7/ubi-minimal

RUN rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
    rpm --install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    microdnf -y update && \
    microdnf -y --enablerepo=epel-testing install pgbouncer postgresql psmisc && \
    microdnf clean all

RUN chown pgbouncer:0 /etc/pgbouncer && \
    chmod g=u /etc/pgbouncer && \
    rm -f /etc/pgbouncer/pgbouncer.ini /etc/pgbouncer/userlist.txt

ADD entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 5432
USER pgbouncer

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
