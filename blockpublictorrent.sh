#!/bin/bash
#
# [For Blazeshosting Seedbox]
#
# GitHub:   https://github.com/mrlongshen/blockpublictorrent-iptables
# Author:   mrlongshen
# URL:      https://blazeshosting.com

echo -n "Blocking public trackers ... "
wget -q -O/etc/trackers https://raw.githubusercontent.com/mrlongshen/blockpublictorrent-iptables/main/trackers
cat >/etc/cron.daily/denypublic<<'EOF'
IFS=$'\n'
L=$(/usr/bin/sort /etc/trackers | /usr/bin/uniq)
for fn in $L; do
        /sbin/iptables -D INPUT -d $fn -j DROP
        /sbin/iptables -D FORWARD -d $fn -j DROP
        /sbin/iptables -D OUTPUT -d $fn -j DROP
        /sbin/iptables -A INPUT -d $fn -j DROP
        /sbin/iptables -A FORWARD -d $fn -j DROP
        /sbin/iptables -A OUTPUT -d $fn -j DROP
done
EOF
chmod +x /etc/cron.daily/denypublic
curl -s -LO https://raw.githubusercontent.com/mrlongshen/blockpublictorrent-iptables/main/hostsTrackers
cat hostsTrackers >> /etc/hosts
echo "${OK}"