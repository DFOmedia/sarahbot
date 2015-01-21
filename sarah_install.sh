#!/bin/bash - 
#====================================================================
#
#   DESCRIPTION: on Debian-based systems, installs dependencies for 
#   sarah, gets source code for sphinx stuff, builds, installs 
#   program, config files, and so forth. USE AT YOUR OWN RISK! 
#   READ THE SCRIPT CAREFULLY AND DECIDE IF YOU WANT TO USE IT
# 
#  REQUIREMENTS: debian-based system, sudo privileges
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Nemanja Kukic - TheDarkByte ()
#       CREATED: 17/01/2014 11:22:41 PM GMT
#====================================================================

user=$(whoami)
builddir="/usr/share"
configdir="/home/$user/.config"

install_deps(){
  buildtools="git build-essential gnome-common bison"
  libs="python-pyside libgstreamer-plugins-base0.10-dev libgstreamer0.10-cil-dev libgstreamer0.10-dev python-gst0.10-dev rygel-gst-launch gstreamer0.10-plugins-good python-sphinx gstreamer0.10-tools python-gtk2 python-gtk2-dev"
  packages="xvkbd xdotool espeak wmctrl elinks xclip curl"
  sudo apt-get update
  sudo apt-get install $buildtools $libs $packages
}

get_sphinx(){
  version="0.8"
  cd /home/$(whoami)
  wget http://sourceforge.net/projects/cmusphinx/files/sphinxbase/$version/sphinxbase-$version.tar.gz
  tar xvf sphinxbase-$version.tar.gz
  cd sphinxbase-$version/
  ./autogen.sh && make && sudo make install
}

get_pocketsphinx(){
  version="0.8"
  cd /home/$(whoami)
  wget http://sourceforge.net/projects/cmusphinx/files/pocketsphinx/$version/pocketsphinx-$version.tar.gz
  tar xvf pocketsphinx-$version.tar.gz
  cd pocketsphinx-$version/
  ./autogen.sh && make && sudo make install
  sudo cp ./src/gst-plugin/.libs/libgstpocketsphinx.so /usr/local/lib/gstreamer-0.10/
}

install_sarahbot() {
	tar xf sarah_data.tar.gz
	sudo cp sarahbot.tar.gz $builddir/sarahbot.tar.gz
	cp sarahbotconf.tar.gz $configdir/sarahbotconf.tar.gz
	rm sarahbot.tar.gz sarahbotconf.tar.gz
	cd $builddir
	sudo tar xf sarahbot.tar.gz
	sudo rm sarahbot.tar.gz
	cd $configdir
	tar xf sarahbotconf.tar.gz
	rm sarahbotconf.tar.gz
	echo "[Desktop Entry]\nEncoding=UTF-8\nVersion=1.1\nType=Application\nTerminal=false\nExec=sh $builddir/sarahbot/start_sarahbot.sh\nName=SarahBot\nIcon=$builddir/sarahbot/data/icon.png\nGenericName[en_US.utf8]=SarahBot! " > /home/$user/Desktop/SarahBot.desktop
	sudo chmod +x /home/$user/Desktop/SarahBot.desktop
	sudo cp /home/$user/Desktop/SarahBot.desktop /usr/share/applications/SarahBot.desktop
	sudo chmod +x /usr/share/applications/SarahBot.desktop
}


install_sarahbot

exit 0
