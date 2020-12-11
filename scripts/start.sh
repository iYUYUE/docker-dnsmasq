#!/bin/sh

/opt/scripts/install-dnsmasq-china-list.sh 
crond
webproc -c /etc/dnsmasq.conf -- dnsmasq --no-daemon
