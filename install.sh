#!/bin/bash

####################################################
####  Install Arch for Rasberry Pi 2 on device  ####
####################################################

# Jan 2 2015


# Don't break anything
echo "
#########################################################
##############      Be Very Careful!!!   ################
#########################################################
"

read -p "Are you going to be careful? " -n 1 -r
echo
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Good. "
    echo "You'll want a second terminal."
else
    echo "Then come back when you're ready to be."
    exit
fi



# Get the device name
if [[ $1 == "" ]]
then
    echo "Enter the device path"
    read DEVICE
else
    read DEVICE
fi

read -p "You entered \"$DEVICE\". Is this right? " -n 1 -r
echo
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Then try again. "
    exit
fi



# Do the silly formatting stuff
read -p "Have you formatted the micro sd card $DEVICE? " -n 1 -r
echo
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Then do this first: "

    # launch fdisk
    echo "   > fdisk /dev/sdX"
    echo

    # Wipe old
    echo "
      At the fdisk prompt, delete old partitions and create a new one:
       > o

      This will clear out any partitions on the drive.
    "

    # First partition
    echo  "
       > n           new
       > p           primary
       > 1           first partition
       > ENTER       to accept the default first sector,
       > +100M       for the last sector.
       > t
       > c           to set the first partition to type W95 FAT32 (LBA).
    "

    # Second partition
    echo "
       > n           new
       > p           primary
       > 2           second partition
       > ENTER       to accept the default  *first*  sector,
       > ENTER       to accept the default  *last*   sector,
    "

    # finish up
    echo "
      Write the partition table and exit by typing:
       > w
    "

    # exit
    echo "After that, exit and re-run this script."
    exit
fi



echo "Using $DEVICE"

# Mount Directory to avoid stupid files
mkdir -p ~/RasberryPi
cd ~/RasberryPi/

if [[ $DEVICE =~ /dev/mmcblk*  ]]
then mkfs.vfat $DEVICE"p1"
else mkfs.vfat $DEVICE"1"
fi

mkdir -p boot

if [[ $DEVICE =~ /dev/mmcblk*  ]]
then mount $DEVICE"p1" boot
else mount $DEVICE"1"  boot
fi





# Create and mount the ext4 filesystem:
if [[ $DEVICE =~ /dev/mmcblk*  ]]
then mkfs.ext4 $DEVICE"p2"
else mkfs.ext4 $DEVICE"2"
fi

mkdir -p root

if [[ $DEVICE =~ /dev/mmcblk*  ]]
then mount $DEVICE"p2" root
else mount $DEVICE"2"  root
fi


# Download and extract the root filesystem (as root, not via sudo):
if [[ ! -f ArchLinuxARM-rpi-latest.tar.gz ]]
then
    echo "Fetching installer"
    wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz

else
    # Fetch new install
    read -p "Fetch a fresh installation? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
	wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz
    fi
fi


# Unpack files
bsdtar -xpf ArchLinuxARM-rpi-latest.tar.gz -C root
sync


# Move boot files to the first partition:
mv root/boot/* boot


# Load files for configuration
mv dotfiles.tar initialize.sh README.md plug.vim root


# Unmount the two partitions:
umount boot root
