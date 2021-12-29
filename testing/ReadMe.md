## Testing Version  
  
wget https://raw.githubusercontent.com/venice1200/MiSTer_i2c2oled/main/testing/update_i2c2oled.sh -O /media/fat/Scripts/update_i2c2oled.sh  
  
Changes/News:  
* Split Daemon Script into Daemon, User and System INI Files.  
  User-INI: /media/fat/i2c2oled/i2c2oled-user.ini  
  
* Added User-INI Option to rotate the display direction for 180 degrees.  
  Default: rotate="no"  
  After changing this Option your Display need a power-cycle.  
  Code taken from the i2c2oled fork from MickGyver. Many Thanks.  
  
* Added User-INI Option for the tiny animation before the picture.  
  Set "animation" to:  
  -1 (default) for Random Animation 1..3  
  0 for NO Animation  
  1 for PressPlay Animation  
  2 for Loading v1 Animation  
  3 for Loading v2 Animation  
  
* Added User-INI Option for Slideshow  
  Default: slideTime=3.0 (Seconds)  
  
  
Slideshow/Picture Viewer:  
* Show all Pictures one by one.  
  Run: **/media/fat/i2c2oled/i2c2oled_slideshow.sh** from ssh/cli  
  Daemon will be stopped before and started after Slideshow.  
  
* Show single Picture.  
  Run: **/media/fat/i2c2oled/i2c2oled_slideshow.sh /media/fat/i2c2oled/Pix/PSX.pix**  
