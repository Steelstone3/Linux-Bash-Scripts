#!/bin/bash

echo "Welcome to Pop_OS! Toolbox please select an option";

#alias update_linux='sudo apt update; apt list --upgradeable; sudo apt upgrade; sudo apt autopurge; sudo apt purge ~c; sudo apt autoclean; flatpak update; flatpak uninstall --unused --delete-data; flatpak repair; sudo chkrootkit';

#echo "update_linux alias added to your system. This will run a series of commands to update and clean your system.";

updateSystem() {
	echo "Updating packages";
        	
        sudo apt update;
        apt list --upgradeable;
        sudo apt upgrade;
        	
        flatpak update;
}

cleanupSystem() {
	echo "Cleaning up Pop_OS!";
        	
        	sudo apt autopurge;
        	sudo apt autoclean;
        	
        	flatpak uninstall --unused --delete-data;
}

upgradeSystem() {
	echo "Upgrading to the latest Pop_OS! version";
        	
        sudo apt update;
	sudo apt full-upgrade;
	pop-upgrade release upgrade;
}

malwareScan() {
	echo "Running chkrootkit package";
        	
      	sudo apt install chkrootkit;
      		
      	sudo chkrootkit;
}

killGraphicalEnviroment() {
	echo "Killing Gnome Shell Session"

	killall -3 gnome-shell
}

resetDisplayManager() {
	echo "Restarting the Display Manager";
                
	sudo systemctl restart gdm;
}

resetNetworking() {
	echo "Restarting the networking service";
        	
	sudo systemctl restart networking;
}

aptRecovery() {
	echo "Attempting to recover apt...";
      		
    	sudo dpkg --configure -a;
	sudo apt update;
	sudo apt install --fix-broken;
	sudo apt install --fix-missing;
}

startupServices() {
	echo "Displaying CRITICAL chain of on boot starup services";
        	
	sudo systemd-analyze critical-chain;
        	
	echo "Use:";
	echo "systemctl enable/disable <service>";
	echo "To enable/disable services as daemons"
}

listAllInstalledAptPackages() {
	echo "Listing installed apt packages";
        	
	apt list --installed;
}

listAllInstalledFlatpakPackages() {
	echo "Listing installed flatpak packages";
        	
       	flatpak list;
}

systemManagement () {
  local PS3='Please enter your choice: '
  local options=("Pop_OS! Update System" "Pop_OS! Cleanup System" "Pop_OS! Upgrade To The Next OS Version" "Run Malware Scan" "Back")
  local opt
  select opt in "${options[@]}"
  do
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
          *) echo "invalid option $REPLY";;
      esac
  done
}

systemRecovery () {
  local PS3='Please enter your choice: '
  local options=("Kill Graphical Enviroment" "Hard Reset Of Display Manager" "Reset Networking" "apt Recovery" "Back")
  local opt
  select opt in "${options[@]}"
  do
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
          *) echo "invalid option $REPLY";;
      esac
  done
}

performance () {
  local PS3='Please enter your choice: '
  local options=("Check On Boot Startup Services" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
	"Check On Boot Startup Services")
		startupServices
		;;
	"Back")
              return
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

aptQuery() {
  local PS3='Please enter your choice: '
  local options=("List All Installed apt Packages" "Find Installed apt Package (To Do)" "Search For Remote apt Package (To Do)" "List All Remote apt Packages (To Do)" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
        "List All Installed apt Packages")
        	listAllInstalledAptPackages
        	;;
        "Find Installed apt Package (To Do)")
        	;;
        "Search For Remote apt Package (To Do)")
        	;;
        "List All Remote apt Packages (To Do)")
        	echo "Listing remote packages";
        	;;
	"Back")
              return
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

flatpakQuery() {
  local PS3='Please enter your choice: '
  local options=("List All Installed Flatpak Packages" "Find Installed Flatpak Package (To Do)" "Search For Remote Flatpak Package (To Do)" "List All Remote Flatpak Packages (To Do)" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
        "List All Installed Flatpak Packages")
        	listAllInstalledFlatpakPackages
        	;;
        "Find Installed Flatpak Package (To Do)")
        	;;
        "Search For Remote Flatpak Package (To Do)")
        	;;
        "List All Remote Flatpak Packages (To Do)")
        	;;
	"Back")
              return
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

packageQuery () {
  local PS3='Please enter your choice: '
  local options=("apt Package Querying" "Flatpak Package Querying" "Back")
  local opt
  select opt in "${options[@]}"
  do
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
          *) echo "invalid option $REPLY";;
      esac
  done
}

main() {
	PS3='Please enter your choice: '
	options=("Pop_OS! Management" "Pop_OS! Recovery" "Pop_OS! Performance" "Pop_OS! Package Query"  "Quit")
	select opt in "${options[@]}"
	do
		case $opt in
    			"Pop_OS! Management")
    				systemManagement
    				;;
       			"Pop_OS! Recovery")
       				systemRecovery
       				;;
       			"Pop_OS! Performance")
       				performance
       				;;
       			"Pop_OS! Package Query")
       				packageQuery
       				;;
        		"Quit")
            			break
            			;;
        		*) echo "invalid option $REPLY";;
		esac
	done
}

main
