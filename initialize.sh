# Script for Rabserry Pi 2:
# Set up for Arch Linux

# take arg in { root, blair } 
case $1 in

#### Root commands ####
root) 

	userdel -r  alarm
	useradd blair
	passwd blair
	passwd

	# > visudo
	# Now uncomment "%wheel ALL=(ALL) ALL"
	pacman -S sudo vim rsync 

	usermod -G10 blair
	exit
;;


#### User commands ####
blair)
	
	# Install some stuff
	sudo pacman -S git zsh moc ranger dfc highlight alsa-utils zip unzip tmux
	
	# Oh-My-Zsh
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
	chsh -s /bin/zsh
	
	#run and quit mocp
	mocp
	
	# Fix the theme
	cp /usr/share/doc/config.example/ ~/.moc/config
	
	# Search for "Theme" and change it to "green_theme"
	amixer sset Master unmute
	
	#These might not be needed
	#   sudo pacman -S pulseaudio pulseaudio-alsa 
	#   pulseaudio --start
	
	# To get audio out of the headphone jack
	sudo modprobe snd_bcm2835
	sudo amixer cset numid=3 1
	
	# To get audio out of the hdmi port
	sudo modprobe snd_bcm2835
	sudo amixer cset numid=3 0

	# Vim settings
	sudo bash -c "echo \"syntax on\"          >> /etc/vimrc"
	sudo bash -c "echo \"colorscheme desert\" >> /etc/vimrc"
	exit
;;



#### Help Message ####
*)
	echo 
	echo "This script is meant to help get an Arch Installatiion onto a Rasberry Pi"
	echo 
	echo "The script only partially automates the process. You'll need a second terminal open."
	echo "To manage this, it's easiest to use TMUX. Recall that "
	echo
	echo "To set up the install, log in as root and run:"
	echo 
	echo "    > ./initialize.sh root"
	echo 
	echo "Then, log out, log into blair, and then run"
	echo 
	echo "    > ./initialize.sh blair"
	echo 
	echo "Then everything should be running."
	exit
;;
