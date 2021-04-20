# 👾 MiSTer_i2c2oled 👾  
  
This Bash-Script-Add-On uses the MiSTer's **i2c Interface** on the DE10-Nano/IO-Board to drive a small SSD1306 OLED Display with 128x64 Pixel  
showing (currently only) Pictures based on the running core.  
  
![i2c2oled](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/SSD1306_MiSTer_small.jpg?raw=true)  
  
**How does it work**  
When the MiSTer boots up the script `/etc/init.d/S60i2c2oled` is called.  
This script does nothing more than calling the script `/usr/bin/i2c2oled.sh` and sent it to the background,  
but only if `/usr/bin/i2c2oled.sh` is found and is executable.  
The Script `/usr/bin/i2c2oled.sh` uses the Linux `source` command to **load** the Picture Data from file if the core has changed.  
The Script uses **i2c** commands like `i2cset` to initialize the Display and calculates the needed values  
out of the loaded Picture Data and send them via **i2c** with the command `i2cset` to the Display.
  
**Picture Modification:**  
The used Pictures are slightly modfied X-PixMap (XPM) Black&White Pictures with 128x64 Pixel.  
You can create X-PixMap Pictures with Gimp.  
After you created the X-PixMap Picture open it with an Text Editor, I use Notepad++, and do the following:
* Switch to Linux Line Ending (LF only)
* Remove all text lines until the first Data Line which should contain a lot Dot's "." and Spaces like `"... . . . ... .. "`
* Add `#!/bin/bash` as first line
* Add `logo=(` before the first **"** so it should look like `logo=("`
* Replace all Dot's "." with "0"'s
* Replace all Spaces " " with "1"'s
* Replace the ending `};` with `)`
* The filename must be the same as the **name of the core** plus `.pix` as extension  
  Example: Corename = **C64**, Filename = **C64.pix**  
* Upload the File(s) to `/media/fat/i2c2oled_pix/` on **MiSTer**
  
Double check the files in https://github.com/venice1200/MiSTer_i2c2oled/tree/main/Pictures/Pix for correct modification.
  
| File/Folder | Description |
| :--- | :--- |
| S60i2c2oled [1] | Starter Script, must be placed in folder `/etc/init.d/` on **MiSTer** |
| i2c2oled [1] | Communication Script, must be placed in folder `/usr/bin/` on **MiSTer** |
| Pictures | Just Pictures |  
| Pictures/Pix | Logos/Pictures in X-PixMap Format, but slightly modified,  must be placed in folder `/media/fat/i2c2oled_pix/` on **MiSTer** |  
  
**Notes:**  
[1]  
Do not forget to make the two Scripts executable after copying them to the MiSTer.  
Use `chmod +x [scriptname]` for this.
  
Thanks to:  
sorgelig for his MiSTer  
https://github.com/MiSTer-devel  
  
Antonio Villena for his RTC Board with i2c connector  
https://www.antoniovillena.es  
  
The following website  
https://stackoverflow.com/questions/42980922/which-commands-do-i-have-to-use-ssd1306-over-i%C2%B2c  
for pointing me into the right direction.  
