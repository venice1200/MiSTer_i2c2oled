# 👾 MiSTer_i2c2oled 👾  
  
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/venice1200/MiSTer_tty2oled/blob/main/LICENSE) ![PICs](https://img.shields.io/badge/Supported_Cores-911-yellow)  
  
Just for fun...  
  
This Bash-Script-MiSTer-Add-On uses the DE10-Nano's **i2c Interface** to drive a small Display  
with 128x64 Pixel showing ~~(currently only)~~ Pictures or Text based on the running core.  
**i2c2oled** is currently supporting SSD1306 (0.98"), SSD1309 (2.42") and SSH1106 (1.3") OLED Displays.  
Antonio Villena build IOBoards with such small SSD1306 Displays and asked for support, so here we are 🙂  
  
![i2c2oled](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/SSD1306_MiSTer_v2.jpg?raw=true)  
  
![>>Short Gif Video<<](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/pressplay.gif?raw=true)

### !! WARNING !! 
This Add-On uses the MiSTer's **i2c Bus**.  
❗ **Wrong usage can confuse the MiSTer's i2c Bus or worse** ❗  
You need to make sure you use the right **i2c Bus** as the MiSTer has more than one.  
  
Use the command `i2cdetect -l` for detecting the correct i2c-Bus  
and `i2cdetect -y [I2CBUS]` for detecting the correct **i2c Address** of your Display, normally 0x3C (Hex).  
On my new DE10-Nano (LOT#0521) the correct I2CBUS Number is 2,  
on my older DE10-Nano (LOT#0519) the correct I2CBUS Number is ~~1~~ also 2 (just checked).  
Normally you get an error message if you try to run `i2cdetect` on the wrong Bus.  
  
![i2cdetect](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/i2cdetect.png?raw=true)
  
### What is needed  
* The DE10-Nano Board  
* A SSD1306, SSD1309 or a SSH1106 OLED Display with i2c Interface  
* An i2c breakout (RTC Boards or IOBoards from Antonio Villena with builtin OLED's)  
  The i2c/SPI Header of the official RTC 1.3 Board has ~no~ a tiny Power Pin.  
  ~Means you have to get the 3.3v Power from another Pin on the Board.~  
  See [Connection Scheme RTC v1.3](https://misterfpga.org/viewtopic.php?p=26036#p26036) for some details.  
  I was sponsored by Antonio Villena with his RTC which has solder Pins for i2c and 3.3v Power.  
  
### Setup  
**NEW:** Installer/Updater by OJAKSCH  
Run the command  
`wget https://raw.githubusercontent.com/venice1200/MiSTer_i2c2oled/main/update_i2c2oled.sh -O /media/fat/Scripts/update_i2c2oled.sh`  
from the MiSTer's command line (F9) or from an SSH Session to download the i2c2oled install/update script to the MiSTer's Script Folder.  
After the Script was downloaded, start it from the MiSTer's Script Menu, the MiSTer's command line (F9) or an SSH Session running the command `/media/fat/Scripts/update_i2c2oled.sh`.  
All needed Files and Pictures are downloaded to the right places and the correct permissions are set.  
  
▶️ Or enable the Option **i2c2oled Files** in **update_all** (see Menu-Misc).  
  
Or (manually) check the **Files&Folders** Table below for which file needs to be placed in which folder on the MiSTer.  
For Setting up the MiSTer for the Autostart Script of i2c2oled run once the command `/media/fat/i2c2oled/S60i2c2oled setup`  
from cli or via ssh to enable Auto-Start of i2c2oled.  
  
### Configuration  
The default configuration is configured in the file `/media/fat/i2c2oled/i2c2oled-system.ini`.  
This file **will be updated** by the updater if new Options are available!  
  
If you nedd to change the settings you can configure **your User settings** by adding Options and their settings  
to the file `/media/fat/i2c2oled/i2c2oled-user.ini`.  
  
Available Options:  
* Option `CONTRAST`  
  Set your Display's Contrast Value from "0..255", default = 100  
  
* Option `ROTATE`  
  Set to "true" for 180 Degree Display Rotation, default = "false"  
  
* Option `ANIMATION`  
  Set to -1 (default) for Random Animation, 0 for NO Animation, 1 for PressPlay, 2..5  for "Loading" Variants  
  
* Option `BLACKOUT`  
  Set to "yes" (default) for the short "Display-Blackout" before a Picture change, "no" = no blackout  
  
* Option `SSD1309`  
  Set to "yes" if you use an SSD1309 Display, "no" is default.  
  This Option activates an one line offset.  
  
* Option `SSH1106`  
  Set to "yes" if you use an SSH1106 Display, "no" is default.  
  This Option activates different Display Ram addressing .  
  
* Option `ONECOLOR`  
  Set to "yes" if you want to use the new "OneColor" and alternatively the "Original" Pictures with header.  
  Set to "no" (default) uses only "Original" Pictures with Header.  

* Option `INVERTHEADER`  
  Set to "yes" if you want the Header of the "original" Two-Color Pictures to be inverted.  
  Useful if you run an One-Color Display. "no" is default.  
  This Option inverts the first 16 lines on Top.  
  
* Option `USE_RANDOM_ALT`  
  Set to "yes" if you want randomly chosen alternative (_altX) PIX as well.  
  Set to "no" (default) if you just want to use the "normal" PIX.  
 
* Options for the **Screensaver**  
  `SCREENSAVER="no"`  
  Set to **yes** to enable the ScreenSaver.  
  `SCREENSAVER_INTERVAL=10`  
  The Screensaver Interval in Seconds.  
  `SCREENSAVER_START=6`  
  The Screensaver starts after **SCREENSAVER_START x SCREENSAVER_INTERVAL** Seconds.  
  `SCREENSAVER_SCREENS=4`  
  Value how many different ScreenSaver Screens are shown.  
  1=Time, 2=Time+Date, 3=Time+Date+"i2c2oled", 4=Time+Date+"i2c2oled"+"MiSTer FPGA",  
  5=Time+Date+"i2c2oled"+"MiSTer FPGA"+Actual Corename  
  
* Options for AD7414 temperature output (see below)  
  `SHOW_TEMP="no"`  
  Set to "yes" in order to show the temperature (default=no)  
  `SHOW_TEMP_ROW=[0..7]`  
  Set the row for the temperature output (default=0)   
  `SHOW_TEMP_COL=[0..128]`  
  Set the column for the temperature output (default=2)  
  `SHOW_TEMP_INTERVAL=[secs]`  
  Set the interval for the temperature output (default=1)  
  
If you need to change the Display i2c Address add the following Option
* Option `oledid`  
  Set your Displays i2c Address by adding the Option `oledid` with your Displays i2c Address.  
  Example: `oledid=3c`  
  ❗ **Important**, you **need** to add the Option `oledaddr=0x${oledid}` **directly** one line behind `oledid`.  
  
### Picture Locations  
* **/media/fat/i2c2oled/Pix**  
  Location of the original Pictures with 16 Pixel Line Header (for the Two-Color SSD1306 Display)  
* **/media/fat/i2c2oled/PRI**  
  Priority/Private Picture folder for the normal Two-Color Pictures.  
  Will not been touched by the Updater.  
* **/media/fat/i2c2oled/Pix_Onecolor**  
  Location of the new Pictures with Footer (for One-Color Displays)   
* **/media/fat/i2c2oled/PRI_Onecolor**  
  Priority/Private Picture folder for the new One-Color Pictures.  
  Will not been touched by the Updater.  
  
### How does it work  
When the MiSTer boots up the script `/media/fat/i2c2oled/S60i2c2oled` is called.  
This script does nothing more than calling the script `/media/fat/i2c2oled/i2c2oled.sh`  
and sent it to the background, but only if `/media/fat/i2c2oled/i2c2oled.sh` is found and is executable.  
The Script `/media/fat/i2c2oled/i2c2oled.sh` uses the Linux `source` command to **load** the Binary Coded Picture Data from file, if the core has changed.  
![i2cdetect](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/XPM_with_01.png?raw=true)  
The Script applies the **i2c** command `i2cset` to initialize the Display and send calculated Picture-Data to the Display.  

### Picture Modification:  
The used Black & White Pictures are slightly modfied X-PixMap (XPM) Pictures with 128x64 Pixel.  
You can create X-PixMap Pictures with Gimp or ImageMagick.  
After you created the Black&White X-PixMap Picture...   
  
🛠️ Use the XPMtoPIX conversion tool **V2** by MickGyver (need .NET Core Framework 3.1+) 🛠️  
Drop the folder which contains your XPM files onto the batch file **XPMToPIX_normal.bat** and check the result.  
If you like the pictures **inverted** drop the folder onto the batch file **XPMToPIX_inverted.bat**.  
  
or open it with an Text Editor, I use Notepad++, and do manually...  
* Switch to Linux Line Ending (LineFeed only)
* Remove all text lines until the first Data Line which should contain a lot Dot's "." and Spaces like `"... . . . "`
* Add `#!/bin/bash` as the new first line
* Add `logo=(` before the first **"** (double quote) so it should look like `logo=("`
* Replace all Dot's "." with the Number "0"
* Replace all Spaces " " with the Number "1"
* Replace the ending `};` with `)`
* The filename must be the same as the **name of the core** plus `.pix` as extension  
  Example: Corename = **C64**, Filename = **C64.pix**  
* Upload the File(s) to `/media/fat/i2c2oled/Pix/` on **MiSTer**
* Have fun 😃  
  
▶️ You can use the [template](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/templates/template.pix) as well.  
  
Check your PIX against the files in [https://github.com/venice1200/MiSTer_i2c2oled/tree/main/Pictures/Pix](https://github.com/venice1200/MiSTer_i2c2oled_Pictures/tree/main/Pictures/Pix) for correct modification.  
  
***>> Please make your PIX available for others <<***

### Slideshow/Picture Viewer:  
**Show all Pictures one by one**  
Run: `/media/fat/i2c2oled/i2c2oled_slideshow.sh` from ssh/cli.  
The i2c2oled Daemon will be stopped before and started after the Slideshow.  
**Show single Picture**  
Run: `/media/fat/i2c2oled/i2c2oled_slideshow.sh [/full/path/to/pix.pix]` from ssh/cli.  
  
### Temperature Sensor Readout  
...by ahmadexp  
  
Support for temerature sensor (AD7414) readout (can be added to the RTC 1.3 board).  
The i2c2oled code can support the readout of the this sensor and can overlay it on the existing image.  
By default the temperature readout is not enabled to make it compatible and issue free for unsupported hardware.  
In order to enable the temperature readout you need to add **SHOW_TEMP="yes"** to your `i2c2oled-user.ini` file.  
You can also change the location of the value readout using **SHOW_TEMP_ROW** and **SHOW_TEMP_COL**.  
In additon, you can chose how often the frequency readout gets updated (per seconds) by adjusting  
the value of **SHOW_TEMP_INTERVAL** which by default is set to 1 update per second.  
As of now that I am writing this guide, there is not ready for purchase RTC 1.3 boards with the AD7414 temperature sensor on them.  
If you wish to build one youself you can purchase the RTC 1.3 board and get the AD7414 from  
Digikey (https://www.digikey.com/catalog/en/partgroup/ad7414-and-ad7415/79942) or  
Mouser (https://www.mouser.com/ProductDetail/Analog-Devices/AD7414?qs=5aG0NVq1C4x8PH0XK0xGUA%3D%3D) and solder it youself.  
You might need a bit of soldering skils to do it right.  
Please consider asking for help from a professional (like an electronic or cellphone repair shop) if you are not comfortable with the SMD soldering.  
Hopefully soon we will have the RTC 1.4 with both the AD7414 as well as I2C pin headers for easier OLED epansion.  
In additon, I am looking to add Temperature based Fan Speed Control to this project (future work).  
If you have any further questions in this regards, please feel free rech out to @ahmadexp for more info. Stay tuned and have fun.  
    
### Files&Folders  
| File/Folder | Description |
| :--- | :--- |
| S60i2c2oled [1] | Starter Script, must be placed in folder `/media/fat/i2c2oled/` on **MiSTer** |
| i2c2oled.sh [1] | Communication Script, must be placed in folder `/media/fat/i2c2oled/` on **MiSTer** |
| i2c2oled-user.ini | User Option File, must be placed in folder `/media/fat/i2c2oled/` on **MiSTer** |
| i2c2oled-system.ini | i2c2oled System File, must be placed in folder `/media/fat/i2c2oled/` on **MiSTer** |
| i2c2oled_slideshow.sh [1] | Slideshow Viewer, must be placed in folder `/media/fat/i2c2oled/` on **MiSTer** | 
| Pictures | Just Pictures |
| -Pix- | See https://github.com/venice1200/MiSTer_i2c2oled_Pictures for all available PIX |  
  
**Notes**  
[1]  
Do not forget to make the three Scripts executable after copying them to the MiSTer.  
Use `chmod +x [scriptname]` for this.
  
### Thanks to  
sorgelig for his MiSTer  
https://github.com/MiSTer-devel  
  
Antonio Villena for his RTC Board with i2c connector  
https://www.antoniovillena.es  
  
MickGyver for his XPMtoPIX conversion Tool  
https://github.com/MickGyver  
  
The following website  
https://stackoverflow.com/questions/42980922/which-commands-do-i-have-to-use-ssd1306-over-i%C2%B2c  
for pointing me into the right direction.  
  
Many Thanks to the Picture Contributors **ingloriond**, **marcelosofth** and **salamantecas**.  
  
...and all I forgot (Sorry!).  
  
### Links  
MiSTer Forum: https://misterfpga.org  
Add-On Thread : https://misterfpga.org/viewtopic.php?f=9&t=2476  
MiSTer on Github: https://github.com/MiSTer-devel  
mr-fitzie's pixviewer: https://venice1200.github.io/MiSTer_tty2oled_Pictures/  
terminator2k2 pics: https://github.com/terminator2k2  
aeronius "OneColor" pics: https://github.com/aeronius/MiSTer_Pix  
  
