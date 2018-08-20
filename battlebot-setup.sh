#!/bin/bash

if [[ "$EUID" -ne 0 ]];
	then echo "You must be root to run this script. Use sudo."
	exit
fi

if [[ $# -lt 1 ]];
	then echo "You need to specify an SSID for the AP!"
	echo "Usage:"
	echo "sudo $0 SSIDGoesHere [password-optional]"
	echo "If you to not specify a password it will be set to raspberry."
	exit
fi

APSSID="$1"
APPASS="raspberry"

if [[ $# -ge 2 ]];
	then APPASS=$2
fi

apt-get remove --purge hostapd -yqq
#apt-get update -yqq # Optional - Update repository list
#apt-get upgrade -yqq # Optional - Upgrade all installed packages - Takes a long time!
apt-get install hostapd dnsmasq -yqq

# Install libraries and packages needed for sensors and robot operation
apt-get install python-dev python3-setuptools libasound-dev portaudio19-dev libportaudio2 libportaudiocpp0 ffmpeg libav-tools -yqq
pip3 install --upgrade pip setuptools

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=192.168.100.100,192.168.100.200,255.255.255.0,24h
EOF

cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
driver=nl80211
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
# Change below values for different AP SSID and password.
ssid=$APSSID
wpa_passphrase=$APPASS
EOF

sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat >> /etc/dhcpcd.conf <<EOF
# Added by Access Point Setup Script
interface wlan0
static ip_address=192.168.100.1/24
denyinterfaces wlan0
nohook wpa_supplicant
EOF

systemctl enable hostapd
systemctl enable dnsmasq

sudo service hostapd start
sudo service dnsmasq start

echo "Setup complete. Now run 'sudo raspi-config' and enable the SSH Server and RPi Camera."
echo "Reboot when finished to enable the AP."
