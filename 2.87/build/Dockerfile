FROM centos:7

EXPOSE 4500 4501 4507
COPY ./v2.87 /opt/trex/v2.87

RUN printf '%s\n' \
    '[base]' \
    'name=CentOS-$releasever - Base' \
    'baseurl=https://vault.centos.org/7.9.2009/os/$basearch/' \
    'gpgcheck=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' \
    'enabled=1' \
    '' \
    '[updates]' \
    'name=CentOS-$releasever - Updates' \
    'baseurl=https://vault.centos.org/7.9.2009/updates/$basearch/' \
    'gpgcheck=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' \
    'enabled=1' \
    '' \
    '[extras]' \
    'name=CentOS-$releasever - Extras' \
    'baseurl=https://vault.centos.org/7.9.2009/extras/$basearch/' \
    'gpgcheck=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' \
    'enabled=1' \
    '' \
    '[centosplus]' \
    'name=CentOS-$releasever - CentOSPlus' \
    'baseurl=https://vault.centos.org/7.9.2009/centosplus/$basearch/' \
    'gpgcheck=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7' \
    'enabled=0' \
    > /etc/yum.repos.d/CentOS-Base.repo && \
    yum install -y python3 nmap-ncat sudo iproute ethtool && \
    yum clean all

WORKDIR /opt/trex/v2.87
ENTRYPOINT ["./entry.sh"]
