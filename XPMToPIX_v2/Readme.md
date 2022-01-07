XPMToPIX by MickGyver
---------------------------
Converts all XPM images in a folder to PIX used by MiSTer i2c2oled.  
  
Usage:  
XPMToPIX [folder]  

If you run XPMToPIX without the folder argument, then XPMToPIX will convert  
all XPM files in the folder where XPMToPIX was run from.  
  
You can supply an optional argument -inv, --inv, -invert, --invert. This  
will invert the colors making a black pixel white on the display and vice  
versa.  
  
  
Added by Venice, 2022-01-07
------------------------------
Drop the folder containing your XPM's onto the Batch file called **"XPMToPIX_normal.bat"**   
to get all XPM's in the folder converted with correct colors.  
  
Drop the folder containing your XPM's onto the Batch file called **"XPMToPIX_invert.bat"**   
to get all XPM's in the folder converted with inverted colors.  

Create XPM's  
Use Gimp's Export Funktion to covert your original to XPM  
or try the ImageMagick commands  
`magick mogrify -monochrome -format xpm *.png`  
`magick mogrify -monochrome -format xpm *.bmp`  
for conversion.
  