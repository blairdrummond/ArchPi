# ArchPi

This is an install guide for Arch Linux on a Raspberry Pi 2. It assumes you have another computer handy.

# What it does

It guides you though

* a) formatting a microsd card for use with the raspberry pi, and
* b) basic setup of the user account and installation of simple tools like

	* vim
	* tmux
	* audio (through alsa)
	* moc

It is strictly terminal based, but it's of course fairly simple to layer a full GUI on top (if you have the space).


# How to use. 

To format the microsd card, run ./install.sh from a linux computer

> ./install.sh

After that, plug the microsd card into the raspberry pi, and log into root and run

> ./initialize.sh
