Proprietary binaries
====

MP3, MP4, FLASH and PDF binaries for ChromiumOS. 
Launch "prop.sh" as root.

To gain superuser privileges :
- Press CTRL-ALT-F2
- The login is 'chronos'
- Type 'sudo su' to enter root shell

To download directly the script in your ChromiumOS, please type : 

    curl -L http://goo.gl/xaxZjM -o prop.sh
    
To launch the bash script, please type :

    bash prop.sh
    
    
***

Do it yourself
===

1) The '.so' files are found in Google Chrome '.deb' package (you'll need Ubuntu or another machine without ChromeOS to read extract .deb files. File-roller works fine for that.) : 

- libffmpegsumo.so for MP3 and MP4
- libpdf.so for PDF
- libpepflashplayer.so & manifest.json for FLASH
- pepper-flash.info for FLASH (read below!!!) 
    
2) 'pepper-flash.info' is a text-file containing : 

      # Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
      # Use of this source code is governed by a BSD-style license that can be
      # found in the LICENSE file.
      
      # Registration file for Pepper Flash player.
    
      FILE_NAME=/opt/google/chrome/pepper/libpepflashplayer.so
      PLUGIN_NAME="Shockwave Flash"
      VERSION="11.3.31.318"
      VISIBLE_VERSION="11.3 r31"
      DESCRIPTION="$PLUGIN_NAME $VISIBLE_VERSION"
      MIME_TYPES="application/x-shockwave-flash"
    
