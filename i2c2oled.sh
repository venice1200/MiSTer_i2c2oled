#!/bin/bash

#
# File: "media/fat/i2c2oled/i2c2oled.sh"
#
# Just for fun ;-)
#
# 2021-04-18 by venice
# License GPL v3
# 
# Using DE10-Nano's i2c Bus and Commands showing the MiSTer Logo on an connected SSD1306 OLED Display
#
# The SSD1306 is organized in eight 8-Pixel-High Pages (=Rows, 0..7) and 128 Columns (0..127).
# I you write an Data Byte you address an 8 Pixel high Column in one Page.
# Commands start with 0x00, Data with 0x40 (as far as I know)
#
# Initial Base for the Script taken from here:
# https://stackoverflow.com/questions/42980922/which-commands-do-i-have-to-use-ssd1306-over-i%C2%B2c
#
# Use Gimp or ImageMagick to convert the original to X-PixMap (XPM) and change " " (Space) to "1" and "." (Dot) to "0" for easier handling
# See examples what to modify additionally
# The String Array has 64 Lines with 128 Chars
# Put your X-PixMap files in /media/fat/i2c2oled_pix with extension "pix"
#
# 2021-04-28
# -Adding Basic Support for an 8x8 Pixel Font taken from https://github.com/greiman/SdFat under the MIT License
#  Use modded ASCII functions from here https://gist.github.com/jmmitchell/c82b03e3fc2dc0dcad6c95224e42c453
# -Cosmetic changes
#
# 2021-04-29/30
# -Adding Font-Based Animation "pressplay" and "loading"
#  The PIX's "pressplay.pix" and "loading.pix" are needed.
#
# 2021-05-01
# -Adding "Warp-5" Scrolling :-)
#  The PIX "ncc1701.pix" is needed.
# -Using "font_width" instead of fixed value.
#
# 2021-05-15
# -Adding OLED Address Detection
#  If Device is not found the Script ends with Error Code 1 
#  Use code from https://raspberrypi.stackexchange.com/questions/26818/check-for-i2c-device-presence
#
# 2021-05-17
# -Adding an "CONTRAST" variable so you can set your contrast value
#
# 2021-12-27
# -Adding "ROTATE" option and code from "MickGyver"
#
# 2021-12-29
# -Split Daemon Script into Daemon, User and System INI Files
# -New Option "ANIMATION" in User INI
#  Set to -1 for Random Animation, 0 for NO Animation, 1 for PressPlay, 2..5  for "Loading" Variations
#
# 2021-12-30
# -New Loading Icons (iload3/iload4)
#
# 2022-01-01 (Happy new Year)
# -New Option "ANIMATION" in User INI
#  Set to "yes" (default) for the short "Display-Blackout" before a Picture change
# -Cosmetics
# 
# 2022-01-10
# -Cosmetics
# -Add Private Picture Folder pripath="/media/fat/i2c2oled/pri"
#
# 2022-02-27
# -Add Support for SSD1309 (2,42") Display (most of these Displays need to be modded from SPI to I2C)
#  New Option SSD1309="yes/no"
# -Copied values with default settings to i2c2oled-system.ini
# -User INI i2c2oled-user.ini got higher priority to overrride default setting in i2c2oled-system.ini
# -Add Contrast function
#
# 2022-04-09
# -Make the client quiet (inotifywait -q)
#
# 2022-05-15
# -Make the client more quiet (inotifywait -qq)
# -Switch Page Adressing from Horizontal Mode to Page Mode (Needed for Support of the SSH1106 Display)
# -Add Support for OneColor Pictures
#  Create the two folders /media/fat/i2c2oled/Pix_Onecolor and/or /media/fat/i2c2oled/PRI_Onecolor and add "OneColor" Pictures here.
#
# 2022-05-19
# -New Option SSH1106="yes/no"
#  Add Support for SSH1106#
#
# 2022-05-20
# -New Option "INVERTHEADER="yes/no"
#  Inverts the first 16 Pixel Lines, useful for TwoColor Displays
#
#


# Load INI files
. /media/fat/i2c2oled/i2c2oled-system.ini
. /media/fat/i2c2oled/i2c2oled-user.ini


# ************************** Main Program **********************************


# Lookup for i2c Device
dbug "i2c2oled Hardware check."
#echo -e "\n\n${fyellow}i2c2oled Hardware check.${freset}"
mapfile -t i2cdata < <(i2cdetect -y ${i2cbus})
for i in $(seq 1 ${#i2cdata[@]}); do
  i2cline=(${i2cdata[$i]})
  echo ${i2cline[@]:1} | grep -q ${oledid}
  if [ $? -eq 0 ]; then
    #echo -e "${fgreen}OLED at 0x${oledid} found, proceed...${freset}"
    dbug "OLED at 0x${oledid} found, proceed..."
    oledfound="true"
  fi
done

if [ "${oledfound}" = "false" ]; then
  #echo -e "${fred}OLED at 0x${oledid} not found, end here!${freset}"
  dbug "OLED at 0x${oledid} not found, end here!"
  exit 1
fi

display_off					# Switch Display off
init_display				# Send INIT Commands
display_on					# Debug
flushscreen					# Fill the Screen completly
display_on					# Switch Display on
sleep 0.5          		    # Small sleep
set_contrast ${CONTRAST}	# Set Contrast
sleep 0.5					# Small sleep
#display_off					# Switch Display off
clearscreen					# Clear the Screen completly
display_on					# Switch Display on

#cfont=${#font[@]}			# Debugging get count font array members
#echo $cfont				# Debugging

set_cursor 31 0				# Set Cursor at Page (Row) 0 to the 32th Pixel (Column)
showtext "i2c2oled"			# Some Text for the Display

set_cursor 19 3				# Set Cursor at Page (Row) 3 to the 20th Pixel (Column)
showtext "MiSTer FPGA"			# Some Text for the Display

set_cursor 19 5				# Set Cursor at Page (Row) 5 to the 20th Pixel (Column)
showtext "by Sorgelig"			# Some Text for the Display

sleep ${SLIDETIME}			# Wait a moment

# reset_cursor

while true; do								# main loop
  if [ -r ${corenamefile} ]; then					# proceed if file exists and is readable (-r)
    newcore=$(cat ${corenamefile})					# get CORENAME
    #echo -e "${fyellow}Read CORENAME: ${fblue}${newcore}${freset}"					# some output
    dbug "Read CORENAME: ${newcore}"					# some debug output
    if [ "${newcore}" != "${oldcore}" ]; then				# proceed only if Core has changed
      dbug "Send ${newcore} to i2c-${i2cbus}"				# some debug output
      if [ ${newcore} != "MENU" ]; then					# If Corename not "MENU"
        #echo "${ANIMATION}"
        if (( ${ANIMATION} ==  -1 )); then				# 
          anirandom=$[$RANDOM%5+1]					# Generate an Random Number between 0 and Modulo_Faktor-1, +1 
        else
          anirandom=${ANIMATION}					# ..or use the anmation type from User-INI
        fi
        #echo "${anirandom}"
        if (( ${anirandom} == 1 )); then
          pressplay							# Run "pressplay" Animation
        elif (( ${anirandom} == 2 )); then
          loading 1							# Run "loading" Animation
        elif (( ${anirandom} == 3 )); then
          loading 2							# Run "loading" Animation
        elif (( ${anirandom} == 4 )); then
          loading 3							# Run "loading" Animation
        elif (( ${anirandom} == 5 )); then
          loading 4							# Run "loading" Animation
        fi		
      fi								# end if
      if [ "${BLACKOUT}" = "yes" ]; then
        display_off
      fi
      if [ ${newcore} = "THEEASTEREGG" ]; then
        manythanksto
      else
        showpix ${newcore}		 				# The "Magic"
      fi
      display_on
      oldcore=${newcore}										# update oldcore variable
    fi  														# end if core check
    current_corenamefile=${corenamefile} #store the current corename
    while [ ${current_corenamefile} = ${corenamefile} ] #loops until change of corename occures 
    do
      if [ "${SHOW_TEMP}" = "yes" ]; then #show temperature 
        read_temperature 
      fi
      sleep 1
    done
    #inotifywait -qq -e modify "${corenamefile}"					# wait here for next change of corename -q for quite
    #inotifywait -e modify -t 5 "${corenamefile}"				# wait here for next change of corename
	#echo "5 secs Timeout"
  else  												# CORENAME file not found
    #echo "File ${corenamefile} not found!"				# some output
    dbug "File ${corenamefile} not found!"				# some debug output
  fi  													# end if /tmp/CORENAME check
done  													# end while


# ************************** End Main Program *******************************
