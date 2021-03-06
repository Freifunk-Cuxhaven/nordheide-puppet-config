#!/bin/bash

maintenance on
service openvpn stop
update-rc.d openvpn disable

ip rule del pref 31001

rm /etc/iptables.d/800-mesh-forward-ACCEPT-eth0
cat >>/etc/iptables.d/800-mesh-forward-ACCEPT-eth0 << EOF
ip4tables -A mesh-forward -o eth0 -j ACCEPT
EOF

rm /etc/iptables.d/910-Masquerade-eth0
cat >>/etc/iptables.d/910-Masquerade-eth0 << EOF
ip4tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
EOF

build-firewall

ip link add name tun-anonvpn type dummy

rm /etc/rclocal.d/dummy-anonvpn-iface
cat >>/etc/rclocal.d/dummy-anonvpn-iface << EOF
ip link add name tun-anonvpn type dummy
EOF


# TODO
# Remove matchings lines from /etc/network/interfaces.d/ffnh-bridge, remove pre-up, post-up and post-down line.
# nano /etc/network/interfaces.d/ffnh-bridge

# remove check-gateway crontab
# disable vpn-watchdogs

# reboot machine and run:
# maintenance off && service ntp start && batctl -m bat-ffnh gw server 1000/1000 && check-services

