# !/bin/sh

# Functoins
installPkg(){
	apt install $1 > /dev/null 2>&1;
}

installSnap(){
	snap install $1 > /dev/null 2>&1;
}

installGit() {
	git clone $1 > /dev/null 2>&1;
	#TODO: instalacion de repositorios
}

aptInstall() { 
	dialog --title "Instalacion" --infobox "Instalando \`$1\` ($n de $total). $1 $2" 5 70
	installPkg "$1"
	}

snapInstall() { 
	dialog --title "Instalacion" --infobox "Instalando \`$1\` ($n de $total). $1 $2" 5 70
	installSnap "$1"
	}

gitInstall() { 
	dialog --title "Instalacion" --infobox "Instalando \`$1\` ($n de $total). $1 $2" 5 70
	installGit "$1"
	}

instalationMain() { \
	curl -Ls "https://raw.githubusercontent.com/Pablo-snz/dotfiles/main/programs.csv" | sed '/^#/d' > /tmp/programs.csv
	total=$(wc -l < programas.csv)
	while IFS=, read -r tag program; do
		n=$(n+1)
		case "$tag" in
			"s") snapInstall "$program";;
			"a") aptInstall "$program";;
			"g") gitInstall "$program";;
		esac
	done < /tmp/programs.csv ;}



#Script

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install dialog > /dev/null 2>&1;
apt insstall snapd > /dev/null 2>&1;
add-apt-repository ppa:regolith-linux/release -y > /dev/null 2>&1;
apt update > /dev/null 2>&1;
apt install regolith-desktop > /dev/null 2>&1;

#i3-config
cp regolith/config/regolith/i3/config $HOME/.config/regolith/i3/config

#compton
mkdir $HOME/.config/regolith/compton 
cp regolith-compositor/init /usr/share/regolith-compositor/init
cp regolith/config/regolith/compton/config $HOME/.config/regolith/i3/config

#i3-status
mkdir $HOME/.config/i3status
cp regolith/config/i3status/config $HOME/.config/i3status/config

#themes
mkdir $HOME/backgrounds
cp themes/background/bg.jpg $HOME/backgrounds/bg.jpg

#Instalamos paquetes
instalationMain

#Enable tap to click
echo 'Section "InputClass"
	        Identifier "libinput touchpad catchall"
	        MatchIsTouchpad "on"
	        MatchDevicePath "/dev/input/event*"
	        Driver "libinput"
			# Enable left mouse button by tapping
			Option "Tapping" "on"
	 EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

#TODO: Disable double tap (?)

#Instalacion anaconda #
cd /temp
curl –O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
bash Anaconda3-2020.02-Linux-x86_64.sh
cd -
