#!/bin/bash
#based on https://wiki.archlinux.org/index.php/Chromium
#modified by MrVaykadji
#based on ChromiumOS amd64 and Google Chrome binaries build on MAY 12 2014

echo "Proprietary binaries : MP3, MP4, PDF, FLASH"
echo "-------------------------------------------"

#You need to be 'su'
if [[ $EUID -ne 0 ]] ; then
echo "Error: You need to be root.
Type 'sudo su' to gain superuser privileges before running this script."
exit 0
fi

echo "- Mounting filesystem ..."
mount -o remount, rw / > prop.tmp

#error occurs too many times, better check that before downloading
if [[ -n `cat prop.tmp` ]] ; then 
    echo "Error: Unable to mount '/' in read-write" 
    rm prop.tmp
    exit 0
else
    rm prop.tmp
fi

#get in working directory
cd /opt

#download archive
echo "- Downloading and extracting archive ..."
wget -o files.tar https://raw.githubusercontent.com/MrVaykadji/misc/master/ChromiumOS/mp3-flash-pdf/files.tar.gz
tar -xf files.tar.gz
rm files.tar.gz

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

rm -r files

echo "Done. Your system needs to reboot."

#Chromium soft reboot
read -p "Do it now (recommended) ? [y/n] "
[[ "$REPLY" != "y" ]] && exit 0
restart ui
