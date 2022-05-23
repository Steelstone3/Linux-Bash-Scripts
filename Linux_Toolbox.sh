#!/bin/bash

OPTIONS_MESSAGE='Please enter your choice: '
INVALID_OPTION='Invalid option'
UNSUPPORTED_MESSAGE='Unsupported on your current operating system'

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
  echo "OpenRC is $UNSUPPORTED_MESSAGE"
}

has_r_unit() {
  echo "Runit is $UNSUPPORTED_MESSAGE"
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
  *) echo "$UNSUPPORTED_MESSAGE" ;;
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
      upgrade_system_to_next_release
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
    sudo apt full-upgrade
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

upgrade_system_to_next_release() {
  determine_os
  check_upgrade_to_next_release
  check_reboot_and_upgrade
}

check_upgrade_to_next_release() {
  echo "Upgrading Operating System"
  read -p "Are you sure? Type - I am sure: " confirm && [[ $confirm == [iI][" "][aA][mM][" "][sS][uU][rR][eE] ]] || return
  
  case $OPERATING_SYSTEM in
  *"$POP_OS"*)
    run_pop_upgrade
    return
    ;;
  *"$FEDORA"*)
    run_fedora_upgrade
    return
    ;;
  *) echo "$UNSUPPORTED_MESSAGE" ;;
  esac
}

run_pop_upgrade() {
  update_system
  pop-upgrade release upgrade
}

run_fedora_upgrade() {
  update_system

  if [ -x "$(command -v dnf-plugin-system-upgrade)" ]; then
    sudo dnf install dnf-plugin-system-upgrade
  fi

  current_fedora_version=$(cat /etc/fedora-release | tr -dc '0-9')
  next_fedora_version=$(current_fedora_version + 1)

  echo "Next Fedora Version: $next_fedora_version"
  sudo dnf system-upgrade download --releasever=$next_fedora_version
}

check_reboot_and_upgrade() {
  read -p "Reboot and upgrade system? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || return

case $OPERATING_SYSTEM in
  *"$POP_OS"*)
    sudo reboot
    return
    ;;
  *"$FEDORA"*)
    sudo dnf system-upgrade reboot
    return
    ;;
  *) echo "$UNSUPPORTED_MESSAGE" ;;
  esac
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
  echo "Snap is $UNSUPPORTED_MESSAGE"
}

system_recovery() {
  local PS3=$OPTIONS_MESSAGE
  local options=("Back" "Replace Desktop Environment" "Hard Reset Desktop Environment" "Reset Display Manager" "Reset Networking" "Recover Package Managers")
  local opt
  select opt in "${options[@]}"; do
    case $opt in
    "Back")
      return
      ;;
    "Replace Desktop Environment")
      replace_desktop_environment
      ;;
    "Hard Reset Desktop Environment")
      hard_reset_desktop_environment
      ;;
    "Reset Display Manager")
      reset_display_manager
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

replace_desktop_environment() {
  replace_desktop_environment_message='Replacing desktop enviroment'
  
  if [ -x "$(command -v gnome-shell)" ]; then
    echo $replace_desktop_environment_message
    gnome-shell --replace & disown
  fi
  if [ -x "$(command -v plasma-shell)" ]; then
    echo $replace_desktop_environment_message
    kquitapp5 plasma-shell && kstart5 plasma-shell
  fi
  if [ -x "$(command -v cinnamon)" ]; then
    echo $replace_desktop_environment_message

    echo $UNSUPPORTED_MESSAGE
  fi
  if [ -x "$(command -v budgie-panel)" ]; then
    echo $replace_desktop_environment_message

    echo $UNSUPPORTED_MESSAGE
  fi
  if [ -x "$(command -v mate-panel)" ]; then
    echo $replace_desktop_environment_message
    mate-panel --replace
  fi
  if [ -x "$(command -v xfwm4)" ]; then
    echo $replace_desktop_environment_message
    xfce4-panel -r && xfwm4 --replace
  fi
  if [ -x "$(command -v lxqt-panel)" ]; then
    echo $replace_desktop_environment_message

    echo $UNSUPPORTED_MESSAGE
  fi
  if [ -x "$(command -v lxpanelctl)" ]; then
    echo $replace_desktop_environment_message
    lxpanelctl restart && openbox --restart
  fi
  if [ -x "$(command -v i3-msg)" ]; then
    echo $replace_desktop_environment_message
    i3-msg restart
  fi
}

hard_reset_desktop_environment() {
  kill_desktop_enviroment_message='Killing desktop enviroment'
  
  if [ -x "$(command -v gnome-shell)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 gnome-shell
  fi
  if [ -x "$(command -v plasma-shell)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 plasma-shell
  fi
  if [ -x "$(command -v plasma-desktop)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 plasma-desktop
  fi
  if [ -x "$(command -v cinnamon)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 cinnamon
  fi
  if [ -x "$(command -v budgie-panel)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 budgie-panel
  fi
  if [ -x "$(command -v mate-panel)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 mate-panel
  fi
  if [ -x "$(command -v xfwm4)" ]; then
    echo $kill_desktop_enviroment_message
    killall -3 xfwm4
  fi
  if [ -x "$(command -v lxqt-panel)" ]; then
    echo $replace_desktop_environment_message
    killall -3 lxqt-panel
  fi
  if [ -x "$(command -v lxpanelctl)" ]; then
    echo $replace_desktop_environment_message
    killall -3 lxpanelctl
  fi
}

reset_display_manager() {
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
      echo "pacman flatpak recovery is $UNSUPPORTED_MESSAGE"
    fi

    echo "Adding Repositories"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi
}

recover_snap() {
  if has_snap; then
    echo "Snap recovery currently is $UNSUPPORTED_MESSAGE"
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
    echo "Pacman recovery is currently is $UNSUPPORTED_MESSAGE"
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
