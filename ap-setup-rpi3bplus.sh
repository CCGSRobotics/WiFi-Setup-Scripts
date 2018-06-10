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
apt-get update -yqq
apt-get upgrade -yqq
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
# Lock AP into 5Ghz mode
hw_mode=a
# Can change channel to 36/40/44/48 if other channels busy. Check first if allowed in country/competition
channel=36
country_code=AU
# Limit channels to those allowed by country_code
ieee80211d=1
# Disable 802.11n to avoid using 2.4Ghz band accidentally
ieee80211n=0
# Enable 801.11ac for 5Ghz band AP
ieee80211ac=1
# Setting below to 0 may improve range but increase risk of interference with other devices
ieee80211h=1
wmm_enabled=1
# HT Capabilities specific to 3B+ onboard card. See 'iw list' output for details.
ht_capab=[HT40][SHORT-GI-20][SHORT-GI-40][DSSS_CCK-40]
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP TKIP
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
