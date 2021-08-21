#!/bin/bash

PS3='Please enter your choice: '
options=("1: Restart Display Manager" "2: Replace Gnome Shell" "3: Kill Gnome Shell" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "1: Restart Display Manager")
                echo "Restarting the Display Manager"
	    	sudo systemctl stop gdm
		sudo systemctl stop lightdm

		sudo systemctl start gdm
		sudo systemctl start lightdm
            	;;
       	"2: Replace Gnome Shell")
	    	echo "Replacing The Gnome Shell"
		gnome-shell --replace
	        ;;
            
        "3: Kill Gnome Shell")
	        echo "Killing Gnome Shell Session"

	   	killall -3 gnome-shell
	        ;;
        "Quit")
            	break
            	;;
        *) echo "invalid option $REPLY";;
    esac
done

