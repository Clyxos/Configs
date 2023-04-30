pacman -S --needed $(cat packages | cut -d' ' -f1)
