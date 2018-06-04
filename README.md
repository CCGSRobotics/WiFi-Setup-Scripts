# rpi-ap-setup-scripts
These scripts configure a Raspberry Pi 3B+ running Debian Stretch to use its onboard WiFi interface as an access point.
This configuration also allows you to connect a second WiFi interface card (i.e. USB dongle) to use as a regular WiFi interface
so that you can connect to a second wireless network (and the Internet) without interfering with the AP.

INSTRUCTIONS
 
1.  Format a Micro SD Card using the SD Formatter tool from https://www.sdcard.org/
2.  Download a fresh copy of NOOBS (with Raspbian Stretch) from https://www.raspberrypi.org/downloads/noobs/
3.  Follow the instructions from the site above to install Raspbian Stretch (or above) onto a Raspberry PI 3B+
4.  Boot the Raspberry Pi using the newly prepared SD card and connect to the Internet (Unfiltered! Use a hotspot if you have to.)
5.  Copy this script to the desktop on the Pi.
6.  Open the Terminal application and browse to the folder containing this script (cd ~/Desktop)
7.  Enter the following: sudo sh ./name-of-this-script.sh SSID-name ap-password-optional -- (default password is 'raspberry')
     Example: 
              sudo sh ./ap-setup-rpi3bplus.sh KingsLegacy supersecretpassword 

8.  Make a cup of tea while you wait for this script to complete.
9.  Reboot.
10.  Test that you can connect to the new AP.

Enjoy!
 
Caution: DO NOT boot the Pi with a WiFi dongle connected. Do this only after the AP has been raised. 
         Leaving a dongle connected during the boot process sometimes prevents the AP from configuring properly.
