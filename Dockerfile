# start with minimal fedora base
FROM fedora:latest

# get the copr plugin
RUN dnf install -y dnf-plugins-core

# install my copr repos
RUN dnf copr enable -y jlayton/ceph
RUN dnf copr enable -y jlayton/nfs-ganesha

# workaround: install was failing until I installed perl-Carp separately
RUN dnf install -y perl-Carp

# now install nfs-ganesha and Ceph FSAL
RUN dnf install -y nfs-ganesha-ceph

# set up ceph.conf
WORKDIR /etc/ceph/
COPY ceph.conf /etc/ceph/

# set up ganesha config
WORKDIR /etc/ganesha/
COPY ganesha.conf /etc/ganesha/

WORKDIR /ceph
RUN chown ganesha:ganesha /ceph

# copy run script
WORKDIR /
COPY run-ganesha.sh /

# export NFS port
EXPOSE 2049

ENTRYPOINT ["/run-ganesha.sh"]
