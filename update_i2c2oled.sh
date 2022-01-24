#!/bin/bash

URL="https://www.tty2tft.de/i2c2oled"
# URL="https://www.tty2tft.de/i2c2oled/testing"
I2C2OLED_PATH="/media/fat/i2c2oled"
USERSTARTUP="/media/fat/linux/user-startup.sh"
USERSTARTUPTPL="/media/fat/linux/_user-startup.sh"
INITSCRIPT="${I2C2OLED_PATH}/S60i2c2oled"
DAEMONNAME="i2c2oled.sh"
export RSYNC_PASSWORD="93CdeEfF49ba92fEd2dEb29efi"

# Stop an already running daemon
if [ $(pidof ${DAEMONNAME}) ]; then
    ${INITSCRIPT} stop
    sleep 0.5
fi

# Check for i2c2oled path's and create it if neccessary, download/update scripts
! [ -d /media/fat/i2c2oled/Pix ] && mkdir -p /media/fat/i2c2oled/Pix
! [ -d /media/fat/i2c2oled/PRI ] && mkdir -p /media/fat/i2c2oled/PRI

# Check update_all.ini for i2c2oled Update/Install Script
if [ $(grep -c "I2C2OLED_FILES_DOWNLOADER=\"true\"" "/media/fat/Scripts/update_all.ini") = "0" ]; then
  cd /media/fat/Scripts
  wget -N --no-use-server-timestamps ${URL}/update_i2c2oled.sh
  [ -x update_i2c2oled.sh ] || chmod +x update_i2c2oled.sh
  sleep 0.5
else
  echo "UPDATE_ALL is responsible for the i2c2oled updater. Skipping Download/Update!"
fi

# Download/Update i2c2oled Scripts
cd /media/fat/i2c2oled
wget -N --no-use-server-timestamps ${URL}/S60i2c2oled ${URL}/i2c2oled.sh ${URL}/i2c2oled_slideshow.sh ${URL}/i2c2oled-system.ini
wget -nc ${URL}/i2c2oled-user.ini
[ -x S60i2c2oled ] || chmod +x S60i2c2oled 
[ -x i2c2oled.sh ] || chmod +x i2c2oled.sh 
[ -x i2c2oled_slideshow.sh ] || chmod +x i2c2oled_slideshow.sh

# Old MiSTer layout: remove init script
[[ -e /etc/init.d/S60i2c2oled ]] && /etc/init.d/S60i2c2oled stop && rm /etc/init.d/S60i2c2oled

# New MiSTer layout: setup init script
if [ ! -e ${USERSTARTUP} ] && [ -e /etc/init.d/S99user ]; then
  if [ -e ${USERSTARTUPTPL} ]; then
    echo "Copying ${USERSTARTUPTPL} to ${USERSTARTUP}"
    cp ${USERSTARTUPTPL} ${USERSTARTUP}
  else
    echo "Building ${USERSTARTUP}"
    echo -e "#!/bin/sh\n" > ${USERSTARTUP}
    echo -e 'echo "***" $1 "***"' >> ${USERSTARTUP}
  fi
fi
if [ $(grep -c "i2c2oled" ${USERSTARTUP}) = "0" ]; then
  echo -e "Adding i2c2oled to ${USERSTARTUP}\n"
  echo -e "\n# Startup i2c2oled" >> ${USERSTARTUP}
  echo -e "[[ -e ${INITSCRIPT} ]] && ${INITSCRIPT} \$1" >> ${USERSTARTUP}
fi

# Synchronize pictures
rsync -crlzzP --modify-window=1 --delete rsync://i2c2oled-update-daemon@tty2tft.de/i2c2oled-pictures/Pix/ ${I2C2OLED_PATH}/Pix/

${INITSCRIPT} start
exit 0
