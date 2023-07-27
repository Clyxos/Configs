#! /bin/bash

pacman -S neovim
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
wait 1 
hwclock --systohc
wait 1
nvim /etc/locale.gen
wait 1
echo "Type your hostname: "
wait 1
read x
echo $x > /etc/hostname
# Install packages
pacman -S --needed $(cat packages | cut -d' ' -f1)
# Make the user
useradd -m -G wheel -s /bin/bash clyxos
# Setup directories
mkdir /home/clyxos/.config
mkdir /home/clyxos/.config/bspwm
mkdir /home/clyxos/.config/sxhkd
mkdir /home/clyxos/.config/picom
mkdir /home/clyxos/.config/polybar
# Put the configs into place
cp bspwmrc /home/clyxos/.config/bspwm/
cp sxhkdrc /home/clyxos/.config/sxhkd
cp picom.conf /home/clyxos/.config/picom/
cp config.ini /home/clyxos/.config/polybar/
cp launch.sh /home/clyxos/.config/polybar/

# Add to the sudoers file
echo "Uncomment the wheel line, then exit and press enter to continue"
wait 3
EDITOR=nvim visudo
read -p "Press enter to continue" yeah
wait 1
passwd
wait 1
passwd clyxos
systemctl enable NetworkManager
read -p "Would you like to use a display manager? (yn)" answer
if [[ $answer = y ]] ; then
	sudo systemctl enable lightdm
fi

read -p "Are you using UEFI? (yn)" answer
if [[ $answer = u ]] 
then
	grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot
else
	grub-install --target=i386-pc /dev/sda
fi
grub-mkconfig -o /boot/grub/grub.cfg

echo "Your system should now be installed"
