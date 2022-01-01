sudo apt update
apt list --upgradeable
sudo apt upgrade
sudo apt autopurge
sudo apt purge ~c
sudo apt autoclean

flatpak update
flatpak uninstall --unused --delete-data
flatpak repair

sudo chkrootkit

alias update_linux='sudo apt update; apt list --upgradeable; sudo apt upgrade; sudo apt autopurge; sudo apt purge ~c; sudo apt autoclean; flatpak update; flatpak uninstall --unused --delete-data; flatpak repair; sudo chkrootkit;'

echo "update_linux alias added to your system. This will run the commands contained in this script."
