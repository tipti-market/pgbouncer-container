FROM registry.access.redhat.com/ubi7/ubi

# Use EPEL 7 package (pre-release)
ENV PGBOUNCER_PACKAGE=https://kojipkgs.fedoraproject.org//packages/pgbouncer/1.12.0/4.el7/x86_64/pgbouncer-1.12.0-4.el7.x86_64.rpm

RUN yum -y --disableplugin=subscription-manager update && \
    yum -y --disableplugin=subscription-manager install ${PGBOUNCER_PACKAGE} && \
    yum --disableplugin=subscription-manager clean all

RUN chown pgbouncer:0 /etc/pgbouncer && \
    chmod g=u /etc/pgbouncer && \
    rm /etc/pgbouncer/pgbouncer.ini

ADD entrypoint.sh /entrypoint.sh
EXPOSE 5432
USER pgbouncer

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
