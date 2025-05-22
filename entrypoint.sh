#!/bin/sh
/usr/libexec/pcp/lib/pmcd start

cd /var/lib/pcp/pmdas/nvidia/
echo "daemon" | ./Install

cd /root

echo "Starting pmlogger, CTL-C to kill"
pmlogger -c /pmlogger.conf /root/thing.archive
