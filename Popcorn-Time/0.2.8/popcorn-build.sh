#!/bin/bash
# Script author: MrVaykadji
# Changes made by Andrew <andrew@webupd8.org>:
#  - use the Popcorn Time icon
#  - added check for apt, dpkg, etc.
#  - added some checks when creating symbolic links
#  - latest GIT requires ruby-compass
#  - build app CSS with ruby compass and place it in the correct folder
#  - it's no longer needed to replace the package.json file
#  - new way of selecting the architecture to build the app for
#  - added installation of compass via gem for Ubuntu 12.04 because the ruby-compass package from Precise is too old and causes the css compilation to fail

###########################################
#deprecated, prevent users from running it
exit 0
###########################################

function checkAPT()
{
sleep 1
for lock in synaptic update-manager software-center apt-get "dpkg " aptitude
do
 if ps -U root -u root u | grep "$lock" | grep -v grep > /dev/null; then 
  echo "Installation won't work. Please close $lock first then try again.";
  exit
 fi
done
}

#information
echo "
Popcorn-Time RC1 for Ubuntu-Linux
------------------------------------
WARNING: Popcorn Time streams movies from Torrents. Downloading copyrighted material may be illegal in your country. Use at your own risk.
"

#verify awareness
read -p "Do you wish to install Popcorn Time [y/n] ? "
if [ "$REPLY" == "y" ] ; then
 sudo echo -e "\nThis may take a while...\n"
else
 exit 0
fi

#dependencies install
checkAPT
echo "- Installing dependencies from repositories..."
if [ `lsb_release -cs` == "precise" ]; then
#work-around for Ubuntu precise having a too old ruby-compass
	sudo add-apt-repository -y ppa:chris-lea/node.js
	sudo apt-get update
    sudo apt-get install nodejs git wget rubygems -y
    sudo gem install compass && echo -e "...Ok.\n"
else
    sudo apt-get install nodejs ruby-compass git wget npm -y
fi

#npm install for CLI
echo "- Installing CLI from 'npm'..."
sudo npm install -g grunt-cli && echo -e "...Ok.\n"

#GIT CLONE GOES HERE
git clone https://github.com/popcorn-official/popcorn-app.git

#check architecture
if [ -n "`arch | grep 64`" ] ; then
    #64bits
    ARCH=linux64
	sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0
else
    #32bits
    ARCH=linux32
	sudo ln -s /lib/i386-linux-gnu/libudev.so.1 /lib/i386-linux-gnu/libudev.so.0
fi

#repair broken nodejs symlink
if [ ! -e /usr/bin/node ]; then
 sudo ln -s /usr/bin/nodejs /usr/bin/node
fi

#install NPM dependencies
cd popcorn-time
echo "- Installing NPM dependencies..."
sudo npm install && echo -e "...Ok.\n"

#build with grunt
echo "- Building with 'grunt'..."
sudo grunt build --platforms=$ARCH && echo -e "...Ok.\n"

#libudev0 fix
cd build/releases/Popcorn-Time/$ARCH/
if [ ! -e /lib/x86_64-linux-gnu/libudev.so.0 ] && [ ! -e /lib/i386-linux-gnu/libudev.so.0 ]; then
 sudo sed -i 's/\x75\x64\x65\x76\x2E\x73\x6F\x2E\x30/\x75\x64\x65\x76\x2E\x73\x6F\x2E\x31/g' Popcorn-Time/Popcorn-Time
fi

#Copy program into /opt
echo "- Installing Popcorn-Time in '/opt/Popcorn-Time/'"
sudo mkdir -p /opt
sudo cp -rf Popcorn-Time /opt
sudo chmod +x /opt/Popcorn-Time/Popcorn-Time
sudo rm -f "/usr/bin/popcorn-time"
sudo ln -s /opt/Popcorn-Time/Popcorn-Time /usr/bin/popcorn-time && echo -e "...Ok.\n"

#fixing playback on 32bit
#if [ "$ARCH" == "linux32" ] ; then
# sudo rm -f "/opt/Popcorn-Time/libffmpegsumo.so"
# wget https://github.com/hotice/webupd8/raw/master/libffmpegsumo.so -O /tmp/libffmpegsumo.so
# sudo cp -f /tmp/libffmpegsumo.so /opt/Popcorn-Time/
#fi

#create launcher
cd ../../../..
echo "- Creating launcher/shortcut in '/usr/share/applications/'..."
sudo cp -f images/icon.png /usr/share/pixmaps/popcorntime.png
echo "[Desktop Entry]
Comment=Watch movies in streaming through P2P and Torrent.
Comment[fr]=Regarder des films en streaming via P2P et Torrent.
Name=Popcorn Time
Exec=/usr/bin/popcorn-time
StartupNotify=false
Type=Application
Icon=popcorntime
Keywords=Streaming;Film;P2P;Torrent;Movie;Cinema
Actions=Kill;

[Desktop Action Kill]
Name=Force close
Name[fr]=Forcer la fermeture
Exec=killall Popcorn-Time
OnlyShowIn=Unity;" | sudo tee /usr/share/applications/popcorn-time.desktop
sudo chmod +x /usr/share/applications/popcorn-time.desktop && echo -e "...Ok.\n"

#create uninstall script
echo "#!/bin/bash
sudo rm /usr/bin/popcorn-time
sudo rm /usr/share/applications/popcorn-time.desktop
sudo rm /usr/share/pixmaps/popcorntime.png
sudo rm -r /opt/Popcorn-Time" | sudo tee /opt/Popcorn-Time/uninstall
sudo chmod +x /opt/Popcorn-Time/uninstall

echo "
Installation done ! Popcorn-time should be now available through : 
- Dash
- Commandline 'popcorn-time'"

read -p "Clean all created directories and temporary files created by the build-process (y/n)? "
[ "$REPLY" == "y" ] && cd .. && sudo rm -rf popcorn-time tmp

exit 0