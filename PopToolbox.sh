#!/bin/bash

echo "Welcome to Pop_OS! Toolbox please select an option";

#alias update_linux='sudo apt update; apt list --upgradeable; sudo apt upgrade; sudo apt autopurge; sudo apt purge ~c; sudo apt autoclean; flatpak update; flatpak uninstall --unused --delete-data; flatpak repair; sudo chkrootkit';

#echo "update_linux alias added to your system. This will run a series of commands to update and clean your system.";

systemManagement () {
  local PS3='Please enter your choice: '
  local options=("Pop_OS! Update System" "Pop_OS! Cleanup System" "Pop_OS! Upgrade To The Next OS Version" "Run Malware Scan" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
          "Pop_OS! Update System")
        	echo "Updating packages";
        	
        	sudo apt update;
        	apt list --upgradeable;
        	sudo apt upgrade;
        	
        	flatpak update;
        	;;
        "Pop_OS! Cleanup System")
        	echo "Cleaning up Pop_OS!";
        	
        	sudo apt autopurge;
        	sudo apt autoclean;
        	
        	flatpak uninstall --unused --delete-data;
        	;;
        "Pop_OS! Upgrade To The Next OS Version")
        	echo "Upgrading to the latest Pop_OS! version";
        	
        	sudo apt update;
		sudo apt full-upgrade;
		pop-upgrade release upgrade;
		;;
	"Run Malware Scan")
        	echo "Running chkrootkit package";
        	
      		sudo apt install chkrootkit;
      		
      		sudo chkrootkit;
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
  local options=("Kill Graphical Enviroment" "Hard Reset Of Display Manager" "Reset Network" "apt Recovery" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
        "Kill Graphical Enviroment")
	    	echo "Killing Gnome Shell Session"

	   	killall -3 gnome-shell
	        ;;
        "Hard Reset Of Display Manager")
                echo "Restarting the Display Manager";
                
	    	sudo systemctl restart gdm;
            	;;
        "Reset Network")
        	echo "Restarting the networking service";
        	
        	sudo systemctl restart networking;
        	;;
        "apt Recovery")
      		echo "Attempting to recover apt...";
      		
      		sudo dpkg --configure -a;
		sudo apt update;
		sudo apt install --fix-broken;
		sudo apt install --fix-missing;
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
		echo "Displaying CRITICAL chain of on boot starup services";
        	
		sudo systemd-analyze critical-chain;
        	
		echo "Use:";
		echo "systemctl enable/disable <service>";
		echo "To enable/disable services as daemons"
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
  local options=("List All Installed Packages" "Find Local Package (To Do)" "Find Remote Package (To Do)" "Back")
  local opt
  select opt in "${options[@]}"
  do
      case $opt in
        "List All Installed Packages")
        	echo "Listing installed packages";
        	
        	apt list --installed;
        	flatpak list;
        	;;
        "Find Local Package (To Do)")
        	;;
        "Find Remote Package (To Do)")
        	;;
	"Back")
              return
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done
}

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

