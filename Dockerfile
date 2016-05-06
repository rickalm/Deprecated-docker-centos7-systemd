# Start with CentOS 7 and repair systemd tools
#
#
FROM centos:7

RUN \
  yum update -y \
  && yum install -y \
    less \
    iproute \
  && yum clean all

# Delete most systemd services
#
RUN \
  (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*

# Fix issue with starting dbus.service
#
RUN \
  mkdir -p /etc/selinux/targeted/contexts/; \
  echo '<busconfig><selinux></selinux></busconfig>' > /etc/selinux/targeted/contexts/dbus_contexts

ENTRYPOINT [ "/usr/sbin/init" ]
#
#
# End of Centos7 Configs
