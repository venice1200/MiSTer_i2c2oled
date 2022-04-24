# 👾 MiSTer_i2c2oled 👾  
  
Just for fun...  
  
This Bash-Script-MiSTer-Add-On uses the DE10-Nano's **i2c Interface** to drive a small SSD1306 OLED Display  
with 128x64 Pixel showing ~~(currently only)~~ Pictures or Text based on the running core.  
Antonio Villena build IOBoards with such small OLED Displays and asked for support, so here we are 🙂  
  
![i2c2oled](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/SSD1306_MiSTer_v2.jpg?raw=true)  
  
![>>Short Gif Video<<](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/pressplay.gif?raw=true)

### !! WARNING !! 
This Add-On uses the MiSTer's **i2c Bus**. Wrong usage can confuse the MiSTer's **i2c Bus or worse**!  
You need to make sure you use the right **i2c Bus** as the MiSTer has more than one.  
  
Use the command `i2cdetect -l` for detecting the correct i2c-Bus  
and `i2cdetect [I2CBUS]` for detecting the correct **i2c Address** of your Display, normally 0x3C (Hex).  
On my new DE10-Nano (LOT#0521) the correct I2CBUS Number is 2,  
on my older DE10-Nano (LOT#0519) the correct I2CBUS Number is ~~1~~ also 2 (just checked).  
Normally you get an error message if you try to run `i2cdetect` on the wrong Bus.  
  
![i2cdetect](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/i2cdetect.png?raw=true)
  
### What is needed  
* The DE10-Nano Board  
* An SSD1306 OLED Display with i2c Interface  
* An i2c breakout (RTC Boards or IOBoards from Antonio Villena with builtin OLED's)  
  The i2c/SPI Header of the official RTC 1.3 Board has no Power Pin, only Data and GND if I am right.  
  Means you have to get the 3.3v Power from another Pin on the Board.  
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
You can configure the User Setting by configuring the file `/media/fat/i2c2oled/i2c2oled-user.ini`.  
User Options:  
* Option `CONTRAST`  
  Set your Display's Contrast Value from "0..255", default = 100  
  
* Option `ROTATE`  
  Set to "true" for 180 Degree Display Rotation, default = "false"  
  
* Option `ANIMATION`  
  Set to -1 (default) for Random Animation, 0 for NO Animation, 1 for PressPlay, 2..5  for "Loading" Variants  
  
* Option `BLACKOUT`  
  Set to "yes" (default) for the short "Display-Blackout" before a Picture change, "no" = no blackout  
  
* Option `SSD1390`  
  Set to "yes" if you use an SSD1309 Display, "no" is default.  
  This Option activates a one line offset.  
  
* Option `ONECOLOR`  
  Set to "yes" if you use a SSD1306 Display with only one Color, "no" is default.  
  This Option inverts the first 16 lines.  
  
If you need to change the Display i2c Address add the following Option
* Option `oledid`  
  Set your Displays i2c Address by adding the Option `oledid` with your Displays i2c Address.  
  Example: `oledid=3c`  
  ❗ **Important**, you **need** to add the Option `oledaddr=0x${oledid}` **directly** one line behind `oledid`.  
  
### How does it work  
When the MiSTer boots up the script `/media/fat/i2c2oled/S60i2c2oled` is called.  
This script does nothing more than calling the script `/media/fat/i2c2oled/i2c2oled.sh`  
and sent it to the background, but only if `/media/fat/i2c2oled/i2c2oled.sh` is found and is executable.  
The Script `/media/fat/i2c2oled/i2c2oled.sh` uses the Linux `source` command to **load** the Binary Coded Picture Data from file, if the core has changed.  
![i2cdetect](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/XPM_with_01.png?raw=true)  
The Script applies the **i2c** command `i2cset` to initialize the Display and send calculated Picture-Data to the Display.  

### Picture Modification:  
The used Black&White Pictures are slightly modfied X-PixMap (XPM) Pictures with 128x64 Pixel.  
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
  
Check your PIX against the files in https://github.com/venice1200/MiSTer_i2c2oled/tree/main/Pictures/Pix for correct modification.  
  
***>> Please make your PIX available for others <<***
  
### Slideshow/Picture Viewer:  
**Show all Pictures one by one**  
Run: `/media/fat/i2c2oled/i2c2oled_slideshow.sh` from ssh/cli.  
The i2c2oled Daemon will be stopped before and started after the Slideshow.  
**Show single Picture**  
Run: `/media/fat/i2c2oled/i2c2oled_slideshow.sh [/full/path/to/pix.pix]` from ssh/cli.  
  
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
  
Many Thanks to the Picture Contributors **ingloriond** and **marcelosofth**  
  
...and all I forgot (Sorry!).  
  
### Links  
MiSTer Forum: https://misterfpga.org  
Add-On Thread : https://misterfpga.org/viewtopic.php?f=9&t=2476  
MiSTer on Github: https://github.com/MiSTer-devel  
mr-fitzie's pixviewer: https://venice1200.github.io/MiSTer_tty2oled_Pictures/  
terminator2k2 pics: https://github.com/terminator2k2
  
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://github.com/venice1200/MiSTer_tty2oled/blob/main/LICENSE)
