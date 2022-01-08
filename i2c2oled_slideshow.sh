#!/bin/bash

#
# File: "/media/fat/i2c2oled/i2c2oled_slideshow.sh"
#
# Just for fun ;-)
#
# 2021-05-03 by venice
# License GPL v3
# 
# Simple Slidehow Player for all availble PIX files
#

# Load INI files
. /media/fat/i2c2oled/i2c2oled-user.ini
. /media/fat/i2c2oled/i2c2oled-system.ini

# Enable Debugging in User INI File
debugfile="/tmp/i2c2oled_slideshow"


# ************************** Main Program **********************************


if [ -z "$1" ]; then
  # Stopping the deamon
  /media/fat/i2c2oled/S60i2c2oled stop

  init_display									# Send INIT Commands
  clearscreen									# Fill the Screen completly

  set_cursor 8 3								# Set Cursor at Page (Row) 2 to the 16th Pixel (Column)
  showtext "PIX Slideshow"						# Some Text for the Display
  sleep ${SLIDETIME}							# Wait a moment

  for pixpic in ${pixpath}/*.${pixextn}; do		# Get Picture
    echo "Showing: ${pixpic}"					# Some output
    source "${pixpic}"							# Load Picture
    sendpix										# ...and show it.
    sleep ${SLIDETIME}
  done

  # Starting the deamon
  /media/fat/i2c2oled/S60i2c2oled start

else
  # Just show one PIX
  echo "Showing: ${1}"							# Just show one picture if given with full path via command line parameter
  source "${1}"									# Load Picture
  sendpix										# ..and show it.
  #sleep 3
fi


# ************************** End Main Program *******************************
