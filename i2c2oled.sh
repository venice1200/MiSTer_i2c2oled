#!/bin/bash

#
# /usr/bin/i2c2oled.sh
#
# Just for fun ;-)
#
# 2021-04-18 by venice
# i2c-Logo v0.1 (Bashversion) License GPL v3
# 
# Using MiSTer's i2c Bus and Commands showing the MiSTer Logo on an SSD1306 OLED Display
#
# Initial Bash Script taken from here
# https://stackoverflow.com/questions/42980922/which-commands-do-i-have-to-use-ssd1306-over-i%C2%B2c
#
# Use Gimp to convert the original to X-PixMap (XPM) and change " " (Space) to "1" and "." (Dot) to "0" for easier handling
# See examples what to modify additionally
# The String Array has 64 Lines with 128 Chars
# Put your X-PixMap files in /media/fat/i2c2oled_pix with extension "pix"
#
#

# Debugging
debug="false"
debugfile="/tmp/i2c2oled"

# Some System Variables
oledaddr=0x3C     #OLED Display I2C Address
# i2cbus=1        # i2c-1, Bus 1, uncomment only one i2c Bus
i2cbus=2          # i2c-2, Bus 2, uncomment only one i2c Bus

# Corerelated
newcore=""
oldcore=""
corenamefile="/tmp/CORENAME"

# Picture related
pixpath="/media/fat/i2c2oled_pix"
pixextn="pix"
pixstart="${pixpath}/starting.pix"
pixnavail="${pixpath}/nopixavail.pix"
pix=""

# Vars
val=""


# Load MiSTer Menu Picture
#. "${pixpath}/menu.pix"
#. "${pixpath}/C64.pix"
#. "${pixpath}/nopixavail.pix"
#. "${pixstart}


# ***** functions ******

# Debug function
dbug() {
  if [ "${debug}" = "true" ]; then
    if [ ! -e ${debugfile} ]; then						# log file not (!) exists (-e) create it
      echo "---------- i2c_oled Debuglog ----------" > ${debugfile}
    fi 
    echo "${1}" >> ${debugfile}							# output debug text
  fi
}

# Display funtions
function display_off() {
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xAE  # Display OFF (sleep mode)
  sleep 0.1
}

function display_on() {
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xAF  # Display ON (normal mode)
  sleep 0.001
}

function init_display() {
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xA8    # Set Multiplex Ratio
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x3F     # value

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xD3    # Set Display Offset
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x00     # no vertical shift

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x40    # Set Display Start Line to 000000b
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xA1    # Set Segment Re-map, column address 127 ismapped to SEG0
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xC8    # Set COM Output Scan Direction, remapped mode. Scan from COM7 to COM0
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0xC0   # Set COM Output Scan Direction, remapped mode. Scan from COM7 to COM0

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xDA    # Set COM Pins Hardware Configuration
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x12   # Alternative COM pin configuration, Disable COM Left/Right remap needed for 128x64
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0x2    # Sequential COM pin configuration,  Disable COM Left/Right remap
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0x22   # Sequential COM pin configuration,  Enable Left/Right remap  (8pixels height)
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0x32    # Alternative COM pin configuration, Enable Left/Right remap   (4pixels height)

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x81    # Set Contrast Control
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xCF     # value, 0x7F max.

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xA4    # display RAM content

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xA6    # non-inverting display mode - black dots on white background

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0xD5    # Set Display Clock (Divide Ratio/Oscillator Frequency)
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x80    # max fequency, no divide ratio

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x8D    # Charge Pump Setting
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x14    # enable charge pump

  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x20    # page addressing mode
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x20    # horizontal addressing mode
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0x21   # vertical addressing mode
  #i2cset -y ${i2cbus} ${oledaddr} 0x00 0x22   # page addressing mode
}

function reset_cursor() {
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x21  #   set column address
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x00  #   set start address
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x7F  #   set end address (127 max)
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x22  #   set page address
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x00  #   set start address
  i2cset -y ${i2cbus} ${oledaddr} 0x00 0x07  #   set end address (7 max)
}

function clearscreen() {
# fill screen with 0x00, send each 32 bytes
  for i in $(seq 32); do
    val=""
    for j in $(seq 32); do
      val=("${val} 0x00")
    done
    i2cset -y ${i2cbus} ${oledaddr} 0x40 ${val} i
  done
  reset_cursor  # Set Corsor to Top-Left
}

function flushscreen() {
# fill screen with 0xff, send each 32 bytes
  for i in $(seq 32); do
    val=""
    for j in $(seq 32); do
      val=("${val} 0xff")
    done
    i2cset -y ${i2cbus} ${oledaddr} 0x40 ${val} i
  done
  reset_cursor  # Set Cursor to Top-Left
}

function show_pix() {
# Get for each 8-Bit Size Vertical Segment the Bits and draw them
  val=""
  for j in 0 7 15 23 31 39 47 55; do
    for i in $(seq 0 127); do
      b0=${logo[j+0]:${i}:1}
      b1=${logo[j+1]:${i}:1}
      b2=${logo[j+2]:${i}:1}
      b3=${logo[j+3]:${i}:1}
      b4=${logo[j+4]:${i}:1}
      b5=${logo[j+5]:${i}:1}
      b6=${logo[j+6]:${i}:1}
      b7=${logo[j+7]:${i}:1}

      #echo "${b8} ${b7} ${b6} ${b5} ${b4} ${b3} ${b2} ${b1} = ${val}"
      let byt=${b7}*128+${b6}*64+${b5}*32+${b4}*16+${b3}*8+${b2}*4+${b1}*2+${b0}*1       # Bits to Decimal
      val=("${val} ${byt}")                                       # The collected Bytes for the "i" Mode
      #echo "Byte: ${byt}"                                        # Debugging Byte
      #echo "Value: ${val}"                                       # Debugging Value
      #sleep 0.1
      if [[ ${i} -eq 31 ||  ${i} -eq 63 || ${i} -eq 95 || ${i} -eq 127 ]]; then    # Send Value every 32 Bytes
        i2cset -y ${i2cbus} ${oledaddr} 0x40 ${val} i             # Send with "i" Mode
        val=""                                                    # Cleanup
      fi # 
    done # for i
  done # for j
}

# i2c Send-Picture function
sendpix() {
  if [ -d "${pixpath}" ]; then					# Check for am existing Picturefolder and proceed
    pix=("${pixpath}/${1}.${pixextn}")			# Build Pix + Path + Extension
    echo "Pix: ${pix}"
    dbug "Pix: ${pix}"
    if [ -f "${pix}" ]; then					# Lookup for an existing PIX and proceed
      source ${pix}								# Load Picture Array
      show_pix								# ..and show it
    else										# No Picture available!
      source ${pixnavail}						# Load Picture Array for no Picture available
      show_pix								# ..and show it
    fi											# End if Picture check
  fi
}


# ************************** Main Program **********************************

display_off     # Switch Display off
init_display    # Send INIT Commands
display_on      # Switch Display on

flushscreen     # Fill the Screen completly

display_on      # Switch Display on


# ** Main **
  source ${pixstart}										# Load Picture Array for no Picture available
  show_pix												# ..and show it
  while true; do											# main loop
    if [ -r ${corenamefile} ]; then							# proceed if file exists and is readable (-r)
      newcore=$(cat ${corenamefile})						# get CORENAME
      echo "Read CORENAME: -${newcore}-"					# some output
      dbug "Read CORENAME: -${newcore}-"					# some debug output
      if [ "${newcore}" != "${oldcore}" ]; then				# proceed only if Core has changed
        dbug "Send -${newcore}- to i2c-${i2cbus}"			# some debug output
        sendpix ${newcore}				 					# The "Magic"
        oldcore=${newcore}									# update oldcore variable
      fi  # end if core check
      inotifywait -e modify "${corenamefile}"				# wait here for next change of corename
    else  # CORENAME file not found
     echo "File ${corenamefile} not found!"					# some output
     dbug "File ${corenamefile} not found!"					# some debug output
    fi  # end if /tmp/CORENAME check
  done  # end while
# ** End Main **

