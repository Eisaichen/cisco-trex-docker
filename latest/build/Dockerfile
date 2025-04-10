FROM centos:8 

EXPOSE 4500 4501 4507
COPY ./v3.06 /opt/trex/v3.06

RUN printf '%s\n' \
    '[baseos]' \
    'name=CentOS Linux $releasever - BaseOS' \
    'baseurl=https://vault.centos.org/$contentdir/$releasever/BaseOS/$basearch/os/' \
    'gpgcheck=1' \
    'enabled=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial' \
    '' \
    '[appstream]' \
    'name=CentOS Linux $releasever - AppStream' \
    'baseurl=https://vault.centos.org/$contentdir/$releasever/AppStream/$basearch/os/' \
    'gpgcheck=1' \
    'enabled=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial' \
    '' \
    '[extras]' \
    'name=CentOS Linux $releasever - Extras' \
    'baseurl=https://vault.centos.org/$contentdir/$releasever/extras/$basearch/os/' \
    'gpgcheck=1' \
    'enabled=1' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial' \
    '' \
    '[plus]' \
    'name=CentOS Linux $releasever - Plus' \
    'baseurl=https://vault.centos.org/$contentdir/$releasever/centosplus/$basearch/os/' \
    'gpgcheck=1' \
    'enabled=0' \
    'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial' \
    > /etc/yum.repos.d/CentOS-Base.repo && \
    rm /etc/yum.repos.d/CentOS-Linux-BaseOS.repo /etc/yum.repos.d/CentOS-Linux-AppStream.repo /etc/yum.repos.d/CentOS-Linux-Extras.repo /etc/yum.repos.d/CentOS-Linux-Plus.repo && \
    yum install -y python39 nmap-ncat sudo && \
    yum clean all

WORKDIR /opt/trex/v3.06
ENTRYPOINT ["./entry.sh"]
