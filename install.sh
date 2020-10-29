# !/bin/sh
read -p "Estás ejecutando el script desde el directorio del repositorio original [N|y] " yn
case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
	* ) exit;;
esac


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
	dialog --title "Instalacion" --infobox "Instalando \`$1\`" 5 70
	installPkg "$1"
	}

snapInstall() { 
	dialog --title "Instalacion" --infobox "Instalando \`$1\`" 5 70
	installSnap "$1"
	}

gitInstall() { 
	dialog --title "Instalacion" --infobox "Instalando \`$1\`" 5 70
	installGit "$1"
	}

instalationMain() { \
	curl -Ls "https://raw.githubusercontent.com/Pablo-snz/dotfiles/main/programs.csv" | sed '/^#/d' > /tmp/programs.csv
	while IFS=, read -r tag program; do
		case "$tag" in
			"s") snapInstall "$program";;
			"a") aptInstall "$program";;
			"g") gitInstall "$program";;
		esac
	done < /tmp/programs.csv ;}


# dialog
sudo apt -y install dialog > /dev/null 2>&1;
dialog --title "Instalacion" --infobox "Instalando curl" 5 70
# curl
sudo apt -y install curl > /dev/null 2>&1;
dialog --title "Instalacion" --infobox "Instalando snap" 5 70
# snap
sudo apt -y install snapd > /dev/null 2>&1;
dialog --title "Instalacion" --infobox " Añadiendo PPA de Regolith" 5 70
# Regolith
sudo add-apt-repository ppa:regolith-linux/release -y > /dev/null 2>&1;
dialog --title "Instalacion" --infobox "Instalando Regolith" 5 70
sudo apt -y install regolith-desktop > /dev/null 2>&1;

# Instalacion paquetes del CSV
instalationMain

# i3-config
dialog --title "Creando directorio" --infobox "Directorio Regolith" 5 70
mkdir -p $HOME/.config/regolith/i3 > /dev/null 2>&1;
cp regolith/config/regolith/i3/config $HOME/.config/regolith/i3/config #> /dev/null 2>&1;

# compton
dialog --title "Creando directorio" --infobox "Directorio Compton" 5 70

mkdir -p $HOME/.config/regolith/compton > /dev/null 2>&1;
mkdir -p /usr/share/regolith-compositor/init;
sudo cp regolith/regolith-compositor/init /usr/share/regolith-compositor/init #> /dev/null 2>&1;
cp regolith/config/regolith/compton/config $HOME/.config/regolith/compton/config #> /dev/null 2>&1;

# i3-status
dialog --title "Creando directorio" --infobox "Directorio i3status" 5 70

mkdir -p $HOME/.config/i3status > /dev/null 2>&1;
cp regolith/config/i3status/config $HOME/.config/i3status/config #> /dev/null 2>&1;

# Temas
dialog --title "Creando directorio" --infobox "Directorio backgrounds" 5 70

mkdir -p $HOME/backgrounds #> /dev/null 2>&1;
cp themes/background/bg.jpg $HOME/backgrounds/bg.jpg #> /dev/null 2>&1;

# Xresources
dialog --title "Poniendo la terminal bonita" --infobox "Xresources" 5 70

# Fondo
cp regolith/Xresources-regolith $HOME/.Xresources-regolith
xrdb .Xresources-regolith

# oh my zsh
dialog --title "Poniendo la terminal bonita" --infobox "Cambiando Bash por zsh \n Instalando zsh" 5 70
sudo apt -y install zsh > /dev/null 2>&1;
dialog --title "Poniendo la terminal bonita" --infobox "Cambiando Bash por zsh \n Configurando zsh por defecto" 5 70
chsh -s $(which zsh)
zsh
dialog --title "Poniendo la terminal bonita" --infobox "Cambiando Bash por zsh \n Instalando Oh My zsh" 5 70

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

mv $HOME/.zshrc $HOME/.zshrcBefore
cp regolith/.zshrc $HOME/.zshrc

# Fondo
dialog --title "Cambiando BG" --infobox "hojas verdes" 5 70
mv themes/background/bj.jpg $HOME/.local/share/backgrounds/j.jpg
gsettings set org.gnome.desktop.background picture-uri file://$HOME/.local/share/backgrounds

# korla
dialog --title "Instalando Tema" --infobox "korla" 
mkdir -p $HOME/.local/share/icons
cd $HOME/.local/share/icons
git clone https://github.com/bikass/korla.git


# Qogir-theme
dialog --title "Instalando Tema" --infobox "Qogir-dark" 
cd /tmp
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme
./install.sh -c dark -t standard 

# Whitesur cursors
dialog --title "Instalando Tema" --infobox "WhiteSur" 
cd /tmp
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
cd WhiteSur-cursors
./install

dialog --title "Instalando Tema" --infobox "Acabando" 

# Tema de GTK
sudo echo "[Settings]
gtk-application-prefer-dark-theme=0
gtk-button-images=1
gtk-cursor-theme-name=WhiteSur-cursors
gtk-decoration-layout=close,minimize,maximize:
gtk-enable-animations=1
gtk-font-name=Noto Sans,  10
gtk-icon-theme-name=korla
gtk-menu-images=1
gtk-primary-button-warps-slider=0
gtk-theme-name=Qogir-dark
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ" > ~/.config/gtk-3.0/settings.ini


# tap to click
echo 'Section "InputClass"
	        Identifier "libinput touchpad catchall"
	        MatchIsTouchpad "on"
	        MatchDevicePath "/dev/input/event*"
	        Driver "libinput"
			# Enable left mouse button by tapping
			Option "Tapping" "on"
#	 EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf

#TODO: Disable double tap (?)

# Instalacion anaconda #
dialog --title "Instalacion" --infobox "Instalando \`Anaconda\`" 5 70

cd $HOME/Descargas || cd $HOME/Downloads

curl https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh > anaconda.sh

zsh anaconda.sh

killall gnome-session-binary