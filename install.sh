# !/bin/sh

# Functoins
installPkg(){
	sudo apt -y install $1 > /dev/null 2>&1;
}

installSnap(){
	sudo snap -y install $1 > /dev/null 2>&1;
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

read -p "Are you running the script from the repository directory? [N|y]" yn
case $yn in
    [Yy]* ) break;;
    [Nn]* ) exit;;
	* ) exit;;
esac


sudo apt -y install dialog > /dev/null 2>&1;
dialog --title "Instalacion" --infobox "Instalando \`snapd\`" 5 70
sudo apt -y insstall snapd > /dev/null 2>&1;
dialog --title "Instalacion" --infobox " \`Añadiendo PPA de Regolith\`" 5 70
sudo add-apt-repository ppa:regolith-linux/release -y > /dev/null 2>&1;
dialog --title "Instalacion" --infobox " \`Actualizando\`" 5 70
sudo apt update > /dev/null 2>&1;
dialog --title "Instalacion" --infobox "Instalando \`Regolith\`" 5 70
sudo apt -y install regolith-desktop > /dev/null 2>&1;

#i3-config
mkdir -p $HOME/.config/regolith/i3 > /dev/null 2>&1;
cp regolith/config/regolith/i3/config $HOME/.config/regolith/i3/config #> /dev/null 2>&1;

#compton
mkdir -p $HOME/.config/regolith/compton > /dev/null 2>&1;
mkdir -p /usr/share/regolith-compositor/init;
cp regolith/regolith-compositor/init /usr/share/regolith-compositor/init #> /dev/null 2>&1;
cp regolith/config/regolith/compton/config $HOME/.config/regolith/i3/config #> /dev/null 2>&1;

#i3-status
mkdir -p $HOME/.config/i3status > /dev/null 2>&1;
cp regolith/config/i3status/config $HOME/.config/i3status/config #> /dev/null 2>&1;

#themes
mkdir -p $HOME/backgrounds #> /dev/null 2>&1;
cp themes/background/bg.jpg $HOME/backgrounds/bg.jpg #> /dev/null 2>&1;

#Instalamos paquetes
instalationMain

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

#Instalacion anaconda #
dialog --title "Instalacion" --infobox "Instalando \`Anaconda\`" 5 70
cd /temp
curl –O https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh > anaconda.sh
bash anaconda.sh
cd -

i3 exit
