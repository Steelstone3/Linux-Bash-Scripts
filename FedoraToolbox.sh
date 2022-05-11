#!/bin/bash

BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "               
             ${BLUE}.',;::::;,'.                
         .';:cccccccccccc:;,.           
      .;cccccccccccccccccccccc;.         
    .:cccccccccccccccccccccccccc:.       
  .;ccccccccccccc;${WHITE}.:dddl:.${BLUE};ccccccc;.    
 .:ccccccccccccc;${WHITE}OWMKOOXMWd${BLUE};ccccccc:.    
.:ccccccccccccc;${WHITE}KMMc${BLUE};cc;${WHITE}xMMc${BLUE}:ccccccc:.   
,cccccccccccccc;${WHITE}MMM.${BLUE};cc;${WHITE};WW:${BLUE}:cccccccc,   
:cccccccccccccc;${WHITE}MMM.${BLUE};cccccccccccccccc:   
:ccccccc;${WHITE}oxOOOo${BLUE};${WHITE}MMM0OOk.${BLUE};cccccccccccc:   
cccccc:${WHITE}0MMKxdd:${BLUE};${WHITE}MMMkddc.${BLUE};cccccccccccc;   
ccccc:${WHITE}XM0'${BLUE};cccc;${WHITE}MMM.${BLUE};cccccccccccccccc'   
ccccc;${WHITE}MMo;${BLUE}ccccc;${WHITE}MMW.${BLUE};ccccccccccccccc;    
ccccc;${WHITE}0MNc.${BLUE}ccc${WHITE}.xMMd${BLUE}:ccccccccccccccc;     
cccccc;${WHITE}dNMWXXXWM0:${BLUE}:cccccccccccccc:,       
cccccccc;${WHITE}.:odl:.${BLUE};cccccccccccccc:,.      
:cccccccccccccccccccccccccccc:'.        
.:cccccccccccccccccccccc:;,..            
  '::cccccccccccccc::;,.${NC} 
"

echo "Welcome to Fedora Toolbox please select an option"

updateSystem() {
  echo "Updating packages"

  sudo dnf update

  flatpak update
}

cleanupSystem() {
  echo "Cleaning up Fedora"

  sudo dnf autoremove
  sudo dnf clean all

  flatpak uninstall --unused --delete-data
}

upgradeSystem() {
  echo "Upgrading to the latest Fedora version"
  
  checkUpgrade
  checkReboot
}

checkUpgrade() {
  read -p "Are you sure? Type - I am sure: " confirm && [[ $confirm == [iI][" "][aA][mM][" "][sS][uU][rR][eE] ]] || return
  sudo dnf upgrade --refresh
  sudo dnf install dnf-plugin-system-upgrade
  
  CURRENT_FEDORA_VERSION=$(cat /etc/fedora-release | tr -dc '0-9')
  NEXT_FEDORA_VERSION=$(($CURRENT_FEDORA_VERSION + 1))
  
  echo "Next Fedora Version:" $NEXT_FEDORA_VERSION
  sudo dnf system-upgrade download --releasever=$NEXT_FEDORA_VERSION
}

checkReboot() {
  read -p "Reboot and upgrade system? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return
  sudo dnf system-upgrade reboot
}

malwareScan() {
  echo "Running chkrootkit package"

  sudo dnf install chkrootkit

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

  sudo systemctl restart NetworkManager.service
}

rpmRecovery() {
  echo "Attempting to recover rpm..."

  sudo rpm --rebuilddb
  sudo rpm -Va
}

flatpakRepair() {
  echo "Attempting to repair flatpak..."

  flatpak repair
}

flatpakRecovery() {  
  echo "Installing flatpak"

  sudo dnf install flatpak

  echo "Adding Repositories"

  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

startupServices() {
  echo "Displaying CRITICAL chain of on boot starup services"

  sudo systemd-analyze critical-chain

  echo "Use:"
  echo "systemctl enable/disable <service>"
  echo "To enable/disable services as daemons"
}

installRpmPackage() {
  echo "Install an rpm package"
  read -p "Enter package name to install: " package

  sudo dnf install ${package}
}

removeRpmPackage() {
  echo "Remove an rpm package"
  read -p "Enter package name to remove: " package

  sudo dnf remove ${package}
}

findInstalledRpmPackage() {
  echo "Find an installed rpm package"
  read -p "Enter search query: " searchQuery

  rpm -q ${searchQuery}
}

findRemoteRpmPackage() {
  echo "Find a remote rpm package"
  read -p "Enter search query: " searchQuery

  dnf search all ${searchQuery}
}

listAllInstalledRpmPackages() {
  echo "Listing all installed rpm packages"

  rpm -qa | sort -V
}

listAllRemoteRpmPackages() {
  echo "Listing all remote rpm packages"

  dnf search all * | sort -V | more
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
  local options=("Back" "Fedora Update System" "Fedora Cleanup System" "Fedora Upgrade To The Next OS Version" "Run Malware Scan")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Fedora Update System")
      updateSystem
      ;;
    "Fedora Cleanup System")
      cleanupSystem
      ;;
    "Fedora Upgrade To The Next OS Version")
      upgradeSystem
      ;;
    "Run Malware Scan")
      malwareScan
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

rpmQuery() {
  local PS3='Please enter your choice: '
  local options=("Back" "Install An rpm Package" "Remove An rpm Package" "Find Installed rpm Package" "Search For Remote rpm Package" "List All Installed rpm Packages" "List All Remote rpm Packages")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Install An rpm Package")
      installRpmPackage
      ;;
    "Remove An rpm Package")
      removeRpmPackage
      ;;
    "Find Installed rpm Package")
      findInstalledRpmPackage
      ;;
    "Search For Remote rpm Package")
      findRemoteRpmPackage
      ;;
    "List All Installed rpm Packages")
      listAllInstalledRpmPackages
      ;;
    "List All Remote rpm Packages")
      listAllRemoteRpmPackages
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

flatpakQuery() {
  local PS3='Please enter your choice: '
  local options=("Back" "Install A Flatpak Package" "Uninstall A Flatpak Package" "Find Installed Flatpak Package" "Search For Remote Flatpak Package" "List All Installed Flatpak Packages" "List All Remote Flatpak Packages")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
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
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

packageQuery() {
  local PS3='Please enter your choice: '
  local options=("Back" "rpm Package Querying" "Flatpak Package Querying")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "rpm Package Querying")
      rpmQuery
      ;;
    "Flatpak Package Querying")
      flatpakQuery
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

performance() {
  local PS3='Please enter your choice: '
  local options=("Back" "Check On Boot Startup Services")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Check On Boot Startup Services")
      startupServices
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

systemRecovery() {
  local PS3='Please enter your choice: '
  local options=("Back" "Kill Graphical Enviroment" "Hard Reset Of Display Manager" "Reset Networking" "rpm Recovery" "Flatpak Recovery" "Flatpak Repair")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Kill Graphical Enviroment")
      killGraphicalEnviroment
      ;;
    "Hard Reset Of Display Manager")
      resetDisplayManager
      ;;
    "Reset Networking")
      resetNetworking
      ;;
    "rpm Recovery")
      rpmRecovery
      ;;
    "Flatpak Recovery")
      flatpakRecovery
      ;;
    "Flatpak Repair")
      flatpakRepair
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

main() {
  PS3='Please enter your choice: '
  options=("Quit" "Fedora Management" "Fedora Package Query" "Fedora Performance" "Fedora Recovery")
  select opt in "${options[@]}"; do
    case $opt in
    "Quit")
      break
      ;;
    "Fedora Management")
      systemManagement
      ;;
    "Fedora Package Query")
      packageQuery
      ;;
    "Fedora Performance")
      performance
      ;;
    "Fedora Recovery")
      systemRecovery
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

main
