FROM registry.access.redhat.com/ubi7/ubi

RUN yum -y --disableplugin=subscription-manager update && \
    yum -y --disableplugin=subscription-manager install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y --disableplugin=subscription-manager --enablerepo=epel-testing install pgbouncer && \
    yum --disableplugin=subscription-manager clean all

RUN chown pgbouncer:0 /etc/pgbouncer && \
    chmod g=u /etc/pgbouncer && \
    rm /etc/pgbouncer/pgbouncer.ini

ADD entrypoint.sh /entrypoint.sh
EXPOSE 5432
USER pgbouncer

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/pgbouncer", "/etc/pgbouncer/pgbouncer.ini"]
