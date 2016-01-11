# Script for Rabserry Pi 2:
# Set up for Arch Linux


pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}

# Uncomment stuff from a file
function uncomment () {

    if [[ $1 == "--file" && $3 == "--pattern" ]]; then
	grep   "^#$4" $2
	sed -i "/$4/s/^#//g" $2

    elif [[ $1 == "--pattern" && $3 == "--file" ]]; then
	grep   "^#$2" $4
	sed -i "/$2/s/^#//g" $4

    else
	echo "uncomment pattern in file

Usage:

    > uncomment --file <file>      --pattern <string>

		or

    > uncomment --pattern <string> --file <file>

"
	exit
    fi
}



# take arg in { root, blair }
case $1 in

    #### Root commands ####
    root)

	userdel -r alarm

	# blair
	useradd blair
	echo "blair's password?"
	passwd blair

	# root
	echo "root password?"
	passwd

	# Grab a few basic packages (we need them for a few things)
	pacman -S sudo vim rsync highlight git

	#Give permissions to wheel
	sudo uncomment --pattern "%wheel ALL=(ALL) ALL" --file /etc/sudoers

	# Add blair to wheel
	usermod -G10 blair

	# Vim settings
	# Centered-Window, Syntax Highlighting, Colour theme
	cp plug.vim /usr/share/vim/vim74/autoload/
	echo "
syntax on
colorscheme desert

call plug#begin('/etc/vim/plugged')
    Plug 'junegunn/goyo.vim'
call plug#end()

autocmd VimEnter * Goyo
" >> /etc/vimrc

	echo "Now we're going to run vim. You need to just ignore any errors and type

    > :PlugInstall

That should install Goyo system wide.
"

	# Copy Files to /home/blair
	mkdir -p /home/blair
	cp initialize.sh /home/blair/
	cp dotfiles.tar /home/blair/
	chmod +x /home/blair/initialize.sh

	# Make certain that user owns their folder
	chown --recursive blair /home/blair

	exit
	;;


    #### User commands ####
    blair)

	# Install some stuff
	sudo pacman -S zsh moc ranger dfc alsa-utils zip unzip tmux

	# Oh-My-Zsh
	echo "Installing zsh. CTRL-D after it finishes (it pauses the script)"
	pause
	sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	#Audio
	sudo gpasswd -a blair audio
	amixer sset Master unmute

	#   These might not be needed
	#   sudo pacman -S pulseaudio pulseaudio-alsa
	#   pulseaudio --start

	# To get audio out of the headphone jack
	sudo modprobe snd_bcm2835
	sudo amixer cset numid=3 1

	#   # To get audio out of the hdmi port
	#   sudo modprobe snd_bcm2835
	#   sudo amixer cset numid=3 0

	# unpack dotfiles
	tar -xf dotfiles.tar
	rm dotfiles.tar

	# Locale
	sudo localectl set-locale LANG=en_US.UTF-8
	export LANG=en_US.UTF-8

	exit
	;;



    #### Help Message ####
    *)
	echo "
	 This script is meant to help get an Arch Installatiion onto a Rasberry Pi

	 The script only partially automates the process. You'll need a second terminal open.
	 To manage this, it's easiest to use TMUX. Recall that

	 To set up the install, log in as root and run:

	     > ./initialize.sh root

	 Then, log out, log into blair, and then run

	     > ./initialize.sh blair

	 Then everything should be running."

	exit
	;;
esac
