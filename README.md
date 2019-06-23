# WiFi-Setup-Scripts
This script configures the on board WiFi interface of a Raspberry Pi 3B+ running Raspbian Stretch to work as an access point.
This configuration also allows you to connect a secondary WiFi interface card (i.e. USB dongle) and use it to connect to 
a second wireless network (and the Internet) without interfering with the AP.

INSTRUCTIONS
----------------
 
1.  Format a Micro SD Card using the SD Formatter tool from https://www.sdcard.org/
2.  Download a fresh copy of NOOBS (with Raspbian Stretch) from https://www.raspberrypi.org/downloads/noobs/
3.  Follow the instructions from the site above to install Raspbian Stretch (or above) onto a Raspberry PI 3B+
4.  Boot the Raspberry Pi using the newly prepared SD card and connect to the Internet (Unfiltered! Use a hotspot if you have to.)
5.  Download this repository and unzip it to the Desktop.
6.  Open the Terminal application and browse to the folder containing this script i.e.
		
			 cd ~/Desktop/WiFi-Setup-Scripts

7.  The script takes two arguments. One for the SSID (required) and one for the password (optional).
    If no password is provided then it will default to 'raspberry'.
    
    __Example Usage:__
    
          sudo bash ./pi3bplus-setup.sh KingsLegacy supersecretpassword
	  
	__Important:__ The above command only works if you are in the same directory as the script.

8.  Make a cup of tea while you wait for the script to complete.
9.  When complete, type `sudo raspi-config` and enable SSH and the Pi Camera.
10. Reboot.

Test that you can connect to the new AP then download the code and enjoy your new robot!
 
__Caution:__ DO NOT boot the Pi with a WiFi dongle connected. Do this only after the AP has been raised. 
         Leaving a dongle connected during the boot process sometimes prevents the AP from being raised properly.
