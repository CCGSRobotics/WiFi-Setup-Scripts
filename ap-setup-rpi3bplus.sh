#!/bin/bash
#
# This script configures the on board WiFi interface of a Raspberry Pi 3B+ running Debian Stretch to work as an access point.
# This configuration also allows you to connect a second WiFi interface card (i.e. USB dongle) to use as a regular WiFi interface
# so that you can connect to a second wireless network (and the Internet) without interfering with the AP.
#
# INSTRUCTIONS
# 
# 1.  Format a Micro SD Card using the SD Formatter tool from https://www.sdcard.org/
# 2.  Download a fresh copy of NOOBS (with Raspbian Stretch) from https://www.raspberrypi.org/downloads/noobs/
# 3.  Follow the instructions from the site above to install Raspbian Stretch (or above) onto a Raspberry PI 3B+
# 4.  Boot the Raspberry Pi using the newly prepared SD card and connect to the Internet (Unfiltered! Use a hotspot if you have to.)
# 5.  Copy this script to the desktop on the Pi.
# 6.  Open the Terminal application and browse to the folder containing this script (cd ~/Desktop)
# 6.  Enter the following: sudo sh ./name-of-this-script.sh SSID-name ap-password-optional -- (default password is 'raspberry')
#     Example: 
#              sudo sh ./ap-setup-rpi3bplus.sh KingsLegacy supersecretpassword 
#
# 7.  Make a cup of tea while you wait for this script to complete.
# 8.  Reboot.
# 9.  Test that you can connect to the new AP.
# 10. Enjoy!
# 
# Caution: DO NOT boot the Pi with a WiFi dongle connected. Do this only after the AP has been raised. 
#          Leaving a dongle connected during the boot process sometimes prevents the AP from configuring properly.


if [ "$EUID" -ne 0 ]
	then echo "Must be root"
	exit
fi

if [[ $# -lt 2 ]]; 
	then echo "You need to specify an SSID for the AP!"
	echo "Usage:"
	echo "sudo $0 SSIDGoesHere [password-optional]"
	echo "If you to not specify a password it will be set to 'raspberry'."
	exit
fi

APSSID="$1"
APPASS="raspberry"

if [[ $# -ge 2 ]]; then
	APPASS=$2
fi

apt-get remove --purge hostapd -yqq
apt-get update -yqq
apt-get upgrade -yqq
apt-get install hostapd dnsmasq -yqq

cat > /etc/dnsmasq.conf <<EOF
interface=wlan0
dhcp-range=192.168.100.100,192.168.100.200,255.255.255.0,24h
EOF

cat > /etc/hostapd/hostapd.conf <<EOF
interface=wlan0
driver=nl80211
hw_mode=a
channel=36
ieee80211n=0
ieee80211ac=1
ieee80211d=1
wmm_enabled=1
ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]
mac_add_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP

# DO NOT CHANGE THE LINES ABOVE
country_code=AU
ssid=$APSSID
wpa_passphrase=$APPASS
EOF

sed -i -- 's/#DAEMON_CONF=""/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat >> /etc/dhcpcd.conf <<EOF
# Added by Access Point Setup Script
interface wlan0
static ip_address="192.168.100.1/24"
denyinterfaces wlan0
nohook wpa_supplicant
EOF

systemctl enable hostapd
systemctl enable dnsmasq

sudo service hostapd start
sudo service dnsmasq start

echo "Setup complete. Reboot now to enable the AP."