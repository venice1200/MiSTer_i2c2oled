# 👾 MiSTer_i2c2oled 👾  
  
This [tty2oled](https://github.com/venice1200/MiSTer_tty2oled) based Bash-Script-Add-On uses the DE10-Nano/IOBoard's **i2c Interface** to drive a small SSD1306 OLED Display with 128x64 Pixel.  
  
![i2c2oled](https://github.com/venice1200/MiSTer_i2c2oled/blob/main/Pictures/SSD1306_MiSTer_small.jpg?raw=true)  
  
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
* The file name should be like the corename the picture should represent with `.pix` as extension  
  Example: Corename **C64** Filename = **C64.pix**  
* Upload the File(s) to `/media/fat/i2c2oled_pix/` on **MiSTer**
  
Double check the files in https://github.com/venice1200/MiSTer_i2c2oled/tree/main/Pictures/Pix for correct modification.
  
| File/Folder | Description |
| :--- | :--- |
| S60i2c2oled [1] | Starter Script, must be placed in folder `/etc/init.d/` on **MiSTer** |
| i2c2oled [1] | Communication Script, must be placed in folder `/usr/bin/` on **MiSTer** |
| Pictures | Just Pictures |  
| Pictures/Pix | Logos/Pictures in X-PixMap Format but slightly modified, must be placed in folder `/media/fat/i2c2oled_pix/` on **MiSTer** |  
  
**Notes:**  
[1]  
Do not forget to make the two Scripts executable after copying them to the MiSTer.  
Use `chmod +x [scriptname]` for this.
