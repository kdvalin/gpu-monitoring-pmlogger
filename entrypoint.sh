#!/bin/sh
cd /var/lib/pcp/pmdas/nvidia/
./Install

/usr/libexec/pcp/lib/pmcd start

cd /root
pmlogger thing.archive
