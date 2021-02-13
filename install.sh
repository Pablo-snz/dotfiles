# !/bin/sh

read -p "Estás ejecutando el script desde el directorio del repositorio original [N|y] " yn
case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
	* ) exit;;
esac

touch ~/logs
installPkg(){
	sudo apt -y install $1
}

installSnap(){
	sudo snap install $1 --classic 
}

installGit() {
	git clone $1 >> logs;
	#TODO: instalacion de repositorios
}

aptInstall() {
	installPkg "$1"
	}

snapInstall() {
	installSnap "$1"
	}

gitInstall() {
	installGit "$1"
	}

instalationMain() { \
	#curl -Ls "https://raw.githubusercontent.com/Pablo-snz/dotfiles/main/programs.csv" | sed '/^#/d' > /tmp/programs.csv
	while IFS=, read -r tag program; do
		case "$tag" in
			"s") snapInstall "$program";;
			"a") aptInstall "$program";;
			"g") gitInstall "$program";;
		esac
	done < programs.csv ;}

sudo apt upgrade

# curl
sudo apt -y install curl

# snap
sudo apt -y install snapd

# Regolith
sudo add-apt-repository ppa:regolith-linux/release -y
sudo apt -y install regolith-desktop

# Instalacion paquetes del CSV
instalationMain

# i3-config
mkdir -p $HOME/.config/regolith/i3
cp regolith/config/regolith/i3/config $HOME/.config/regolith/i3/config #> /dev/null 2>&1;

# compton
mkdir -p $HOME/.config/regolith/compton
sudo mkdir -p /usr/share/regolith-compositor;
sudo cp regolith/regolith-compositor/init /usr/share/regolith-compositor/init #> /dev/null 2>&1;
cp regolith/config/regolith/compton/config $HOME/.config/regolith/compton/config #> /dev/null 2>&1;

# i3-status
mkdir -p $HOME/.config/i3status
cp regolith/config/i3status/config $HOME/.config/i3status/config #> /dev/null 2>&1;

# Rofi
sudo apt -y install rofi
mkdir -p ~/.config/rofi/
cp -r regolith/rofi/* ~/.config/rofi/

# Temas

mkdir -p $HOME/backgrounds #> /dev/null 2>&1;
cp themes/background/bg.jpg $HOME/backgrounds/bg.jpg #> /dev/null 2>&1;

# Xresources

# Fondo
cp regolith/Xresources-regolith $HOME/.Xresources-regolith
xrdb ~/.Xresources-regolith

# oh my zsh
sudo apt -y install zsh

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

mv $HOME/.zshrc $HOME/.zshrcBefore
cp regolith/.zshrc $HOME/.zshrc

# Fondo
mkdir -p $HOME/.local/share/backgrounds/
cp themes/background/bg.jpg $HOME/.local/share/backgrounds/j.jpg
gsettings set org.gnome.desktop.background picture-uri file://$HOME/.local/share/backgrounds/j.jpg


# Instalando fuentes:
mkdir -p $HOME/.fonts
cp -r fonts/* $HOME/.fonts/
fc-cache -v

# Cambiando las fuentes:
gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Text 10.5'
gsettings set org.gnome.desktop.interface font-name 'SF Pro Text 10.5'
gsettings set org.gnome.desktop.interface monospace-font-name 'Monospace 11'

# tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Task-warrior y Time-warrior
cp -r regolith/timetaskwarrior/taskrc $HOME/.taskrc
mkdir -p $HOME/.task
cp -r regolith/timetaskwarrior/task/* $HOME/task
mkdir -p $HOME/.timewarrior
cp -r regolith/timetaskwarrior/timewarrior/* $HOME/.timewarrior
chmod +x $HOME/.task/hooks/on-modify.timewarrior

# dunst
cp -r regolith/dunst/ $HOME/.config/dunst

# Volume-notifications
mkdir -p $HOME/.scripts
cp -r regolith/scripts/* $HOME/.scripts/

cd /tmp
git clone https://github.com/multiplexd/brightlight.git
cd brightlight
make
sudo cp brightlight /usr/bin/brightlight
cd /usr/bin
sudo chown root brightlight
sudo chmod u+s brightlight

# Chrome 
cd /tmp
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# Firefox ERROR
mkdir -p $HOME.mozilla/firefox/*.default-release/chrome/
cp themes/userChrome.css $HOME/.mozilla/firefox/*.default-release/chrome/userChrome.css

# korla
mkdir -p $HOME/.local/share/icons
cd $HOME/.local/share/icons
git clone https://github.com/bikass/korla.git
mv korla korla2
cp -r korla2/* .
rm -rf f* i* L* R* korla2/

gsettings set org.gnome.desktop.interface icon-theme 'kora-light'

# Qogir-theme
cd /tmp
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-theme
./install.sh -c light -t standard

gsettings set org.gnome.desktop.interface gtk-theme 'Qogir-light'




sudo mkdir -p /etc/X11/xorg.conf.d/
# tap to click
sudo echo 'Section "InputClass"
	        Identifier "libinput touchpad catchall"
	        MatchIsTouchpad "on"
	        MatchDevicePath "/dev/input/event*"
	        Driver "libinput"
			# Enable left mouse button by tapping
			Option "Tapping" "on"
#	 EndSection' > /etc/X11/xorg.conf.d/40-libinput.conf


# Instalacion anaconda

sudo rm -rf /tmp/*

cd $HOME/Descargas || cd $HOME/Downloads

read -p "Descargar anaconda ahora? [N|y] " yn
case $yn in
    [Yy]* ) curl https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh > anaconda.sh;;
    [Nn]* ) ;;
	* );;
esac

dialog --title "Cambiando a ZSH" --infobox "Poniendo por defecto zsh" 5 70

chsh -s $(which zsh)
