# 👾 MiSTer_i2c2oled 👾  
  
Just for fun...  
  
This Bash-Script-Add-On uses the MiSTer's **i2c Interface** on the DE10-Nano  
to drive a small SSD1306 OLED Display with 128x64 Pixel showing (currently only) Pictures based on the running core.  
Antonio Villena builds IOBoards with such small OLED Displays and asked for support, so here we are 🙂  
  
![i2c2oled](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/SSD1306_MiSTer_small.jpg?raw=true)  
  
[>>Short Gif Video<<](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/i2c2oled_life.gif)

### !! WARNING !! 
This Add-On uses the MiSTer's **i2c Bus**. Wrong usage can confuse the MiSTer's **i2c Bus or worse**!  
You need to make sure you use the right **i2c Bus** as the MiSTer has more than one.  
  
Use the command `i2cdetect -l` for detecting the correct i2c-Bus  
and `i2cdetect [I2CBUS]` for detecting the correct **i2c Address** of your Display, normally 0x3C.  
On my new DE10-Nano the correct I2CBUS Number is 2, on my older DE10-Nano the correct I2CBUS Number is 1.  
Normally you get an error message if you try to run `i2cdetect` on the wrong Bus.  
  
![i2cdetect](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/i2cdetect.png?raw=true)
  
### How does it work  
When the MiSTer boots up the script `/etc/init.d/S60i2c2oled` is called.  
This script does nothing more than calling the script `/usr/bin/i2c2oled.sh`  
and sent it to the background, but only if `/usr/bin/i2c2oled.sh` is found and is executable.  
The Script `/usr/bin/i2c2oled.sh` uses the Linux `source` command to **load** the Picture Data from file if the core has changed.  
The Script uses the **i2c** command `i2cset` to initialize the Display and calculates the needed values  
out of the loaded Picture Data and send these values via **i2c** to the Display.
  
### Picture Modification:  
The used Black&White Pictures are slightly modfied X-PixMap (XPM) Pictures with 128x64 Pixel.  
You can create X-PixMap Pictures with Gimp.  
After you created the Black&White X-PixMap Picture open it with an Text Editor, I use Notepad++, and do the following:
* Switch to Linux Line Ending (LineFeed only)
* Remove all text lines until the first Data Line which should contain a lot Dot's "." and Spaces like `"... . . . "`
* Add `#!/bin/bash` as the new first line
* Add `logo=(` before the first **"** (double quote) so it should look like `logo=("`
* Replace all Dot's "." with the Number "0"
* Replace all Spaces " " with the Number "1"
* Replace the ending `};` with `)`
* The filename must be the same as the **name of the core** plus `.pix` as extension  
  Example: Corename = **C64**, Filename = **C64.pix**  
* Upload the File(s) to `/media/fat/i2c2oled_pix/` on **MiSTer**
  
Double check the files in https://github.com/venice1200/MiSTer_i2c2oled/tree/main/Pictures/Pix for correct modification.
  
### Files&Folders  
| File/Folder | Description |
| :--- | :--- |
| S60i2c2oled [1] | Starter Script, must be placed in folder `/etc/init.d/` on **MiSTer** |
| i2c2oled [1] | Communication Script, must be placed in folder `/usr/bin/` on **MiSTer** |
| Pictures | Just Pictures |  
| Pictures/Pix | X-PixMap Pictures, slightly midified, must be placed in folder `/media/fat/i2c2oled_pix/` on **MiSTer** |  
  
**Notes**
[1]  
Do not forget to make the two Scripts executable after copying them to the MiSTer.  
Use `chmod +x [scriptname]` for this.
  
### Thanks to    
sorgelig for his MiSTer  
https://github.com/MiSTer-devel  
  
Antonio Villena for his RTC Board with i2c connector  
https://www.antoniovillena.es  
  
The following website  
https://stackoverflow.com/questions/42980922/which-commands-do-i-have-to-use-ssd1306-over-i%C2%B2c  
for pointing me into the right direction.  
