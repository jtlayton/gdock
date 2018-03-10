#!/bin/bash

[[ `hostname` =~ -([0-9]+)$ ]] || exit 1
ordinal=${BASH_REMATCH[1]}

if [ -z "${ordinal}" ]; then
	echo '$ordinal is unset!'
	exit 1
fi

# Now, start (or join) the grace period
exec rados_grace_tool ${ordinal}
