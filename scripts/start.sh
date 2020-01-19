#!/bin/sh

/opt/scripts/install-dnsmasq-china-list.sh 

webproc -c /etc/dnsmasq.conf -- dnsmasq --no-daemon
