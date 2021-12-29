#!/bin/bash

# URL="https://www.tty2tft.de/i2c2oled"
URL="https://www.tty2tft.de/i2c2oled/testing"
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

# Check for i2c2oled path and create it if neccessary, download/update scripts
! [ -d /media/fat/i2c2oled/Pix ] && mkdir -p /media/fat/i2c2oled/Pix
cd /media/fat/i2c2oled
wget -q -N ${URL}/S60i2c2oled ${URL}/i2c2oled.sh ${URL}/i2c2oled_slideshow.sh ${URL}/i2c2oled-user.ini ${URL}/i2c2oled-system.ini
wget -q -N ${URL}/update_i2c2oled.sh -O /media/fat/Scripts/update_i2c2oled.sh
chmod +x S60i2c2oled i2c2oled.sh i2c2oled_slideshow.sh /media/fat/Scripts/update_i2c2oled.sh

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
