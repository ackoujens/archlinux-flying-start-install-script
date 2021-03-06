# archlinux-flying-start-install-script
Rush into your new Arch Linux project without those annoying preliminary steps.
This script will install arch linux on your computer by using a USB drive.

## Installation steps
1. Download Arch Linux from the [official website](https://www.archlinux.org/download/)
(torrent option is recommended)
2. Place the downloaded .iso file in the root folder
3. Rename the .iso file to "archlinux.iso"
4. Run the provided script.sh file

## The inner workings
When you're done downloading your Arch Linux iso, you will need to place this iso into your root folder and start the script.sh file.

This script will disassemble your iso and insert a one time configuration script in the /etc/profile.d folder.
By doing this, this script will run when logging in.

Arch is also modified to be automatically logged into the root account. This way we can also omit the login step and enables me to run the setup script immediately.

Your usb drive will be formatted and will flash the reassembled iso.

After the script is done with the dd operation, you will need to put your usb-drive into your server/computer and start it up.
Be sure to set your boot order so the usb drive will be used on boot, or you can do it manually by hitting the designated key on startup.

You'll see the configuration script pop up. After all instructions are done, the script will remove itself, including the install.txt file which will provide no further use IMO.
