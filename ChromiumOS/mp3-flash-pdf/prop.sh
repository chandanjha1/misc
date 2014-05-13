#!/bin/bash
#based on https://wiki.archlinux.org/index.php/Chromium
#modified by MrVaykadji
#based on ChromiumOS amd64 and Google Chrome binaries build on MAY 12 2014

#You need to be 'su'

echo "Proprietary binaries : MP3, MP4, PDF, FLASH"
echo "-------------------------------------------"

cd /opt

echo "- Mounting filesystem ..."
mount -o remount, rw /

#download archive
echo "- Downloading and extracting archive ..."
wget -o /files.tar http://example.com
tar -xf files.tar
rm files.tar

#prepare directories
echo "- Creating requested directories ..."
mkdir -p /usr/lib/mozilla/plugins/
mkdir -p /usr/lib/cromo/
mkdir -p /opt/google/chrome/pepper/

#MP3,MP4
echo "- Copying MP3 and MP4 binaries to system ..."
cp files/libffmpegsumo.so /usr/lib/cromo/ -f
cp files/libffmpegsumo.so /opt/google/chrome/ -f
cp files/libffmpegsumo.so /usr/lib/mozilla/plugins/ -f

#PDF
echo "- Copying PDF binary to system ..."
cp files/libpdf.so /opt/google/chrome/ -f

#FLASH
echo "- Copying Chrome's PepperFlash to system ..."
cp files/libpepflashplayer.so /opt/google/chrome/pepper/ -f
cp files/manifest.json /opt/google/chrome/pepper/ -f
cp files/pepper-flash.info /opt/google/chrome/pepper/pepper-flash.info

echo "Done. Your system will now reboot."
sleep 2

#Chromium soft reboot
restart ui
