# !/bin/sh
# Auto-rice script for ubuntu 20.04

# Functoins


installPkg(){
	sudo apt install $1 > /dev/null 2>&1;
}


#write(){

#}



sudo add-apt-repository ppa:regolith-linux/release -y > /dev/null 2>&1;
sudo apt update > /dev/null 2>&1;
sudo apt install regolith-desktop > /dev/null 2>&1;

#Enable tap to click
#echo 'Section "InputClass"
#	        Identifier "libinput touchpad catchall"
#	        MatchIsTouchpad "on"
#	        MatchDevicePath "/dev/input/event*"
#	        Driver "libinput"
#			# Enable left mouse button by tapping
#			Option "Tapping" "on"
#	 EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

#TODO: Disable double tap (?)