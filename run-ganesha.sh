#!/bin/bash

[[ `hostname` =~ -([0-9]+)$ ]] || exit 1
ordinal=${BASH_REMATCH[1]}

if [ -z "${ordinal}" ]; then
	echo '$ordinal is unset!'
	exit 1
fi

sed -i "s/%nodeid%/${ordinal}/" /etc/ganesha/ganesha.conf

if [ -z "${CEPH_MON_ADDR}" ]; then
	echo 'No mon addr specified!'
	exit 1
fi

sed -i "s/%mon_addr%/${CEPH_MON_ADDR}/" /etc/ceph/ceph.conf

exec setpriv				\
	--reuid ganesha 		\
	--regid ganesha			\
	--clear-groups			\
	--inh-caps=-all			\
	--bounding-set=-all		\
	/usr/bin/ganesha.nfsd -L STDOUT -N NIV_DEBUG -p /tmp/ganesha -F
