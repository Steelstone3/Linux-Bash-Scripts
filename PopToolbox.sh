#!/bin/bash

echo "Welcome to Pop_OS! Toolbox please select an option"

#alias update_linux='sudo apt update; apt list --upgradeable; sudo apt upgrade; sudo apt autopurge; sudo apt purge ~c; sudo apt autoclean; flatpak update; flatpak uninstall --unused --delete-data; flatpak repair; sudo chkrootkit';

#echo "update_linux alias added to your system. This will run a series of commands to update and clean your system.";

updateSystem() {
  echo "Updating packages"

  sudo apt update
  apt list --upgradeable
  sudo apt upgrade

  flatpak update
}

cleanupSystem() {
  echo "Cleaning up Pop_OS!"

  sudo apt autopurge
  sudo apt autoclean

  flatpak uninstall --unused --delete-data
}

upgradeSystem() {
  echo "Upgrading to the latest Pop_OS! version"

  sudo apt update
  sudo apt full-upgrade
  pop-upgrade release upgrade
}

malwareScan() {
  echo "Running chkrootkit package"

  sudo apt install chkrootkit

  sudo chkrootkit
}

killGraphicalEnviroment() {
  echo "Killing Gnome Shell Session"

  killall -3 gnome-shell
}

resetDisplayManager() {
  echo "Restarting the Display Manager"

  sudo systemctl restart gdm
}

resetNetworking() {
  echo "Restarting the networking service"

  sudo systemctl restart networking
}

aptRecovery() {
  echo "Attempting to recover apt..."

  sudo dpkg --configure -a
  sudo apt update
  sudo apt install --fix-broken
  sudo apt install --fix-missing
}

startupServices() {
  echo "Displaying CRITICAL chain of on boot starup services"

  sudo systemd-analyze critical-chain

  echo "Use:"
  echo "systemctl enable/disable <service>"
  echo "To enable/disable services as daemons"
}

installAptPackage() {
  echo "Install an apt package"
  read -p "Enter package name to install: " package

  sudo apt install ${package}
}

removeAptPackage() {
  echo "Remove an apt package"
  read -p "Enter package name to remove: " package

  sudo apt remove ${package}
}

findInstalledAptPackage() {
  echo "Find an installed apt package"
  read -p "Enter search query: " searchQuery

  apt list --installed | grep ${searchQuery} --ignore-case --color=auto
}

findRemoteAptPackage() {
  echo "Find an installed apt package"
  read -p "Enter search query: " searchQuery

  apt list | grep ${searchQuery} --ignore-case --color=auto
}

listAllInstalledAptPackages() {
  echo "Listing all installed apt packages"

  apt list --installed
}

listAllRemoteAptPackages() {
  echo "Listing all remote apt packages"

  apt list | more
}

installFlatpakPackage() {
  echo "Install a flatpak package"
  read -p "Enter package name to install: " package

  flatpak install ${package}
}

uninstallFlatpakPackage() {
  echo "Uninstall a flatpak package"
  read -p "Enter package name to install: " package

  flatpak uninstall ${package}
}

findInstalledFlatpakPackage() {
  echo "Find an installed flatpak package"
  read -p "Enter search query: " searchQuery

  flatpak list | grep ${searchQuery} --ignore-case --color=auto
}

findRemoteFlatpakPackage() {
  echo "Find an installed flatpak package"
  read -p "Enter search query: " searchQuery

  flatpak remote-ls | grep ${searchQuery} --ignore-case --color=auto
}

listAllInstalledFlatpakPackages() {
  echo "Listing installed flatpak packages"

  flatpak list
}

listAllRemoteFlatpakPackages() {
  echo "Listing all remote flatpak packages"

  flatpak remote-ls | more
}

systemManagement() {
  local PS3='Please enter your choice: '
  local options=("Pop_OS! Update System" "Pop_OS! Cleanup System" "Pop_OS! Upgrade To The Next OS Version" "Run Malware Scan" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Pop_OS! Update System")
      updateSystem
      ;;
    "Pop_OS! Cleanup System")
      cleanupSystem
      ;;
    "Pop_OS! Upgrade To The Next OS Version")
      upgradeSystem
      ;;
    "Run Malware Scan")
      malwareScan
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

aptQuery() {
  local PS3='Please enter your choice: '
  local options=("Install An apt Package" "Remove An apt Package" "Find Installed apt Package" "Search For Remote apt Package" "List All Installed apt Packages" "List All Remote apt Packages" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Install An apt Package")
      installAptPackage
      ;;
    "Remove An apt Package")
      removeAptPackage
      ;;
    "Find Installed apt Package")
      findInstalledAptPackage
      ;;
    "Search For Remote apt Package")
      findRemoteAptPackage
      ;;
    "List All Installed apt Packages")
      listAllInstalledAptPackages
      ;;
    "List All Remote apt Packages")
      listAllRemoteAptPackages
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

flatpakQuery() {
  local PS3='Please enter your choice: '
  local options=("Install A Flatpak Package" "Uninstall A Flatpak Package" "Find Installed Flatpak Package" "Search For Remote Flatpak Package" "List All Installed Flatpak Packages" "List All Remote Flatpak Packages" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Install A Flatpak Package")
      installFlatpakPackage
      ;;
    "Uninstall A Flatpak Package")
      uninstallFlatpakPackage
      ;;
    "Find Installed Flatpak Package")
      findInstalledFlatpakPackage
      ;;
    "Search For Remote Flatpak Package")
      findRemoteFlatpakPackage
      ;;
    "List All Installed Flatpak Packages")
      listAllInstalledFlatpakPackages
      ;;
    "List All Remote Flatpak Packages")
      listAllRemoteFlatpakPackages
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

packageQuery() {
  local PS3='Please enter your choice: '
  local options=("apt Package Querying" "Flatpak Package Querying" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "apt Package Querying")
      aptQuery
      ;;
    "Flatpak Package Querying")
      flatpakQuery
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

performance() {
  local PS3='Please enter your choice: '
  local options=("Check On Boot Startup Services" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Check On Boot Startup Services")
      startupServices
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

systemRecovery() {
  local PS3='Please enter your choice: '
  local options=("Kill Graphical Enviroment" "Hard Reset Of Display Manager" "Reset Networking" "apt Recovery" "Back")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Kill Graphical Enviroment")
      killGraphicalEnviroment
      ;;
    "Hard Reset Of Display Manager")
      resetDisplayManager
      ;;
    "Reset Networking")
      resetNetworking
      ;;
    "apt Recovery")
      aptRecovery
      ;;
    "Back")
      return
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

main() {
  PS3='Please enter your choice: '
  options=("Pop_OS! Management" "Pop_OS! Package Query" "Pop_OS! Performance" "Pop_OS! Recovery" "Quit")
  select opt in "${options[@]}"; do
    case $opt in
    "Pop_OS! Management")
      systemManagement
      ;;
    "Pop_OS! Package Query")
      packageQuery
      ;;
    "Pop_OS! Performance")
      performance
      ;;
    "Pop_OS! Recovery")
      systemRecovery
      ;;
    "Quit")
      break
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

main
