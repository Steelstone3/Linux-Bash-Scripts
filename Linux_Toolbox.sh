#!/bin/bash

OPTIONS_MESSAGE='Please enter your choice: '
INVALID_OPTION='Invalid option'

DEBAIN='Debain'
UBUNTU='Ubuntu'
POP_OS='Pop!_OS'
FEDORA='Fedora'
MANJARO='Manjaro'

has_flatpak() {
  [ -x "$(command -v flatpak)" ]
}

has_snap() {
  [ -x "$(command -v snap)" ]
}

has_apt() {
  [ -x "$(command -v apt)" ]
}

has_dnf() {
  [ -x "$(command -v dnf)" ]
}

has_pacman() {
  [ -x "$(command -v pacman)" ]
}

has_systemd() {
  [ -x "$(command -v systemctl)" ]
}

has_open_rc() {
  echo "OpenRC currently not supported"
}

has_r_unit() {
  echo "Runit currently not supported"
}

display_pop_welcome_message() {
  CYAN='\033[0;36m'
  WHITE='\033[1;37m'
  NC='\033[0m' # No Color

  echo -e "             ${CYAN}/////////////
           /////////////////////
        ///////${WHITE}*767${CYAN}////////////////
      //////${WHITE}7676767676*${CYAN}//////////////
     /////${WHITE}76767${CYAN}//${WHITE}7676767${CYAN}//////////////
    /////${WHITE}767676${CYAN}///${WHITE}*76767${CYAN}///////////////
   ///////${WHITE}767676${CYAN}///${WHITE}76767.${CYAN}///${WHITE}7676*${CYAN}///////
  /////////${WHITE}767676${CYAN}//${WHITE}76767${CYAN}///${WHITE}767676${CYAN}////////
  //////////${WHITE}76767676767${CYAN}////${WHITE}76767${CYAN}/////////
  ///////////${WHITE}76767676${CYAN}//////${WHITE}7676${CYAN}//////////
  ////////////${WHITE},7676,${CYAN}///////${WHITE}767${CYAN}///////////
  /////////////${WHITE}*7676${CYAN}///////${WHITE}76${CYAN}////////////
  ///////////////${WHITE}7676${CYAN}////////////////////
   ///////////////${WHITE}7676${CYAN}///${WHITE}767${CYAN}////////////
    //////////////////////${WHITE}'${CYAN}////////////
     //////${WHITE}.7676767676767676767,${CYAN}//////
      /////${WHITE}767676767676767676767${CYAN}/////
        ///////////////////////////
           /////////////////////
               /////////////${NC}
  "

  echo "Welcome to Pop_OS! Toolbox please select an option"
}

display_fedora_welcome_message() {
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
}

determine_os() {
  OPERATING_SYSTEM=$(cat /etc/*-release | grep "pretty_name" --ignore-case)
}

display_os_welcome_message() {
  determine_os

  case $OPERATING_SYSTEM in
  *"$POP_OS"*)
    display_pop_welcome_message
    return
    ;;
  *"$FEDORA"*)
    display_fedora_welcome_message
    return
    ;;
  *) echo "Unsupported OS" ;;
  esac
}

system_management() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "System Update" "System Cleanup" "System Upgrade To The Next OS Version")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "System Update")
      update_system
      ;;
    "System Cleanup")
      cleanup_system
      ;;
    "System Upgrade To The Next OS Version")
      #      upgrade_system_to_next_release
      echo "Currently not supported"
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

update_system() {
  echo "Updating System"

  if has_flatpak; then
    sudo flatpak update
  fi
  if has_apt; then
    sudo apt update
    sudo apt upgrade
    return
  elif has_dnf; then
    sudo dnf update --refresh
    return
  elif has_pacman; then
    sudo pacman -Syyu
    return
  fi
}

cleanup_system() {
  echo "Cleaning System"

  if has_flatpak; then
    sudo flatpak uninstall --unused --delete-data
  fi
  if has_apt; then
    sudo apt autopurge
    sudo apt autoclean
    return
  elif has_dnf; then
    sudo dnf autoremove
    sudo dnf clean all
    return
  elif has_pacman; then
    sudo pacman -Rs
    return
  fi
}

package_querying() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "System Package Querying" "Flatpak Package Querying" "Snap Package Querying")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "System Package Querying")
      system_package_querying
      ;;
    "Flatpak Package Querying")
      flatpak_querying
      ;;
    "Snap Package Querying")
      snap_querying
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

system_package_querying() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "Install A System Package" "Remove A System Package" "Find An Installed System Package" "Search For A Remote System Package" "List All Installed System Packages" "List All Remote System Packages")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Install A System Package")
      install_system_package
      ;;
    "Remove A System Package")
      remove_system_package
      ;;
    "Find An Installed System Package")
      find_installed_system_package
      ;;
    "Search For A Remote System Package")
      find_remote_system_package
      ;;
    "List All Installed System Packages")
      list_all_installed_system_packages
      ;;
    "List All Remote System Packages")
      list_all_remote_system_packages
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

install_system_package() {
  echo "Install a system package"
  read -p "Enter package name to install: " package

  if has_apt; then
    sudo apt install ${package}
    return
  elif has_dnf; then
    sudo dnf install ${package}
    return
  elif has_pacman; then
    sudo pacman -S ${package}
    return
  fi
}

remove_system_package() {
  echo "Remove a system package"
  read -p "Enter package name to remove: " package

  if has_apt; then
    sudo apt remove ${package}
    return
  elif has_dnf; then
    sudo dnf remove ${package}
    return
  elif has_pacman; then
    sudo pacman -Rs ${package}
    return
  fi
}

find_installed_system_package() {
  echo "Find an installed system package"
  read -p "Enter search query: " searchQuery

  if has_apt; then
    apt list --installed | grep ${searchQuery} --ignore-case --color=auto
    return
  elif has_dnf; then
    rpm -q ${searchQuery}
    return
  elif has_pacman; then
    pacman -Qs ${searchQuery}
    return
  fi
}

find_remote_system_package() {
  echo "Find a remote system package"
  read -p "Enter search query: " searchQuery

  if has_apt; then
    apt list | grep ${searchQuery} --ignore-case --color=auto
    return
  elif has_dnf; then
    dnf search all ${searchQuery}
    return
  elif has_pacman; then
    pacman -Ss ${searchQuery}
    return
  fi
}

list_all_installed_system_packages() {
  echo "Listing all installed system packages"

  if has_apt; then
    apt list --installed
    return
  elif has_dnf; then
    rpm -qa | sort -V
    return
  elif has_pacman; then
    pacman -Q
    return
  fi
}

list_all_remote_system_packages() {
  echo "Listing all remote system packages"

  if has_apt; then
    apt list | more
    return
  elif has_dnf; then
    dnf search all * | sort -V | more
    return
  elif has_pacman; then
    echo "MAY NOT WORK REQUIRES TESTING"
    pacman -S
    return
  fi
}

flatpak_querying() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "Install A Flatpak Package" "Uninstall A Flatpak Package" "Find An Installed Flatpak Package" "Search For Remote Flatpak Package" "List All Installed Flatpak Packages" "List All Remote Flatpak Packages")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Install A Flatpak Package")
      install_flatpak_package
      ;;
    "Uninstall A Flatpak Package")
      uninstall_flatpak_package
      ;;
    "Find An Installed Flatpak Package")
      find_installed_flatpak_package
      ;;
    "Search For Remote Flatpak Package")
      find_remote_flatpak_package
      ;;
    "List All Installed Flatpak Packages")
      list_all_installed_flatpak_packages
      ;;
    "List All Remote Flatpak Packages")
      list_all_remote_flatpak_packages
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

install_flatpak_package() {
  echo "Install a flatpak package"
  read -p "Enter package name to install: " package

  flatpak install ${package}
}

uninstall_flatpak_package() {
  echo "Uninstall a flatpak package"
  read -p "Enter package name to install: " package

  flatpak uninstall ${package}
}

find_installed_flatpak_package() {
  echo "Find an installed flatpak package"
  read -p "Enter search query: " searchQuery

  flatpak list | grep ${searchQuery} --ignore-case --color=auto
}

find_remote_flatpak_package() {
  echo "Find an installed flatpak package"
  read -p "Enter search query: " searchQuery

  flatpak remote-ls | grep ${searchQuery} --ignore-case --color=auto
}

list_all_installed_flatpak_packages() {
  echo "Listing installed flatpak packages"

  flatpak list
}

list_all_remote_flatpak_packages() {
  echo "Listing all remote flatpak packages"

  flatpak remote-ls | more
}

snap_querying() {
  echo "Not currently implemented"
}

system_recovery() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "Reset Graphics Environment" "Reset Networking" "Recover Package Managers")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Reset Graphics Environment")
      reset_graphics_environment
      ;;
    "Reset Networking")
      reset_networking
      ;;
    "Recover Package Managers")
      recover_package_managers
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

reset_graphics_environment() {
  echo "Restarting the Display Manager"

  if has_systemd; then
    if [ -x "$(command -v gdm)" ]; then
      sudo systemctl restart gdm
    elif [ -x "$(command -v sddm)" ]; then
      sudo systemctl restart sddm
    elif [ -x "$(command -v lightdm)" ]; then
      sudo systemctl restart lightdm
    fi
  fi
}

reset_networking() {
  echo "Restarting the networking service"

  if has_systemd; then
    sudo systemctl restart NetworkManager.service
  fi
}

recover_package_managers() {
  recover_flatpak
  recover_snap
  recover_system_package_manager
}

recover_flatpak() {
  if has_flatpak; then
    echo "Installing flatpak"
    if has_apt; then
      sudo apt install flatpak
    elif has_dnf; then
      sudo dnf install flatpak
    elif has_pacman; then
      echo "pacman flatpak recovery is currently not supported"
    fi

    echo "Adding Repositories"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
}

recover_snap() {
  if has_snap; then
    echo "Snap recovery currently not supported"
  fi
}

recover_system_package_manager() {
  if has_apt; then
    echo "Attempting to recover apt..."
    sudo dpkg --configure -a
    sudo apt update
    sudo apt install --fix-broken --fix-missing
    return
  elif has_dnf; then
    echo "Attempting to recover rpm..."
    sudo rpm --rebuilddb
    sudo rpm -Va
    return
  elif has_pacman; then
    echo "Pacman recovery is currently not supported"
    return
  fi
}

main() {
  display_os_welcome_message

  PS3=$OPTIONS_MESSAGE
  options=("Quit" "OS Management" "OS Package Querying" "OS Recovery")
  select opt in "${options[@]}"; do
    case $opt in
    "Quit")
      break
      ;;
    "OS Management")
      system_management
      ;;
    "OS Package Querying")
      package_querying
      ;;
    "OS Recovery")
      system_recovery
      ;;
    *) echo "$INVALID_OPTION $REPLY" ;;
    esac
  done
}

main
