#!/bin/bash
clear

echo '
# ************************************************ #
#       archlinux-flying-start-install-script      #
#              written by Jens Ackou               #
#                                                  #
#       install arch linux with a USB drive        #
# ************************************************ #
! Press CTRL + C anytime to abort the shell script !
     This is part 2 of the installation process
'

# Display all commands (DEBUG)
# set -x

# Installation Info
# -----------------
# This second part of the installation will handle everything to install your arch system on your hard drive.
# For these installation steps I used this page to make sure all the basics are included:
# https://wiki.archlinux.org/index.php/Installation_guide
#
# You can modify this file to your own needs as this script will be injected into your iso in the first part of the installation process in our "script.sh" file.
# I will not halt this part of the procedure because my intention of this project is that I should not be bothered with a monitor or keyboard to complete the installation process.
# When this script is done I will be able to continue my operation over SSH.
#
# Nothing stops you to alter this configuration for your workstation. This script should be ideal to preconfigure your favorite custom flavor of arch, whatever it may be.

echo '
Cleanup
-------'
sudo rm install.txt
echo 'DONE
'

echo '
Checking For UEFI Boot Mode
---------------------------
Additional modifications are needed if this command returns a positive feedback'
ls /sys/firmware/efi/efivars
echo 'DONE
'

echo '
All Mounted Volumes
-------------------'
lsblk
echo "Enter the location of your USB-drive (ex: /dev/sdb):"
read uservolume
echo '
'

echo '
Repartitioning Drive
--------------------'
##uservolume="/dev/sda"
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk $uservolume
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +100M # 100 MB boot parttion
  t # change partition systemid
  c # ... to W95 FAT32 (LBA)
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +1G # default, extend partition to end of disk
  t # change partition systemid
  2 # selecting second partition
  82 # ... to W95 FAT32 (LBA)
  n # new partition
  p # primary partition
  3 # partion number 3
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  p # display partition table
  w # write the partition table
EOF
partprobe
echo 'DONE
'

echo '
Creating Filesystem
-------------------'
echo "[root] ${uservolume}3 => ext4"
sudo mkfs.ext4 ${uservolume}3
#mkdir root # create root directory
sudo mount ${uservolume}3 /mnt # mount root partition

echo "[boot] ${uservolume}1 => vfat"
sudo mkfs.vfat ${uservolume}1 # create filesystem
mkdir /mnt/boot # create boot directory
sudo mount ${uservolume}1 /mnt/boot # mount boot partition

echo "[swap] ${uservolume}2"
mkswap /dev/sda2
swapon /dev/sda2
echo 'DONE
'

echo '
Selecting Mirrors
-----------------'
# /etc/pacman.d/mirrorlist
echo 'SKIPPED
'

echo '
Installing Base Packages
------------------------'
# Instructions suggest to include bootloader software here?
# If so, their names need to be appended to pacstrap.
pacstrap /mnt base
echo 'DONE
'

echo '
Generating Fstab File
---------------------'
genfstab -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab
echo 'DONE
'

echo '
Changing Root To New System
---------------------------'
curl https://raw.githubusercontent.com/ackoujens/archlinux-flying-start-install-script/master/chroot.sh > /mnt/chroot.sh
chmod +x /mnt/chroot.sh
arch-chroot /mnt /bin/bash -c "./chroot.sh"
echo 'DONE
'

echo '
Cleanup
-------'
rm /etc/chroot.sh
umount -R /mnt
echo 'SKIPPED
# '

# Disable showing all commands
set +x

echo "
+++ That's all folks! Enjoy! +++"
reboot
