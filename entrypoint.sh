#!/bin/sh
exec 2>&1

umask 077
ulimit -n 64000
ulimit -l unlimited

exec /usr/share/elasticsearch/bin/elasticsearch --default.path.conf=/etc/elasticsearch
