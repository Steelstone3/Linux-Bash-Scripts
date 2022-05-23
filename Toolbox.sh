OPTIONS_MESSAGE='Please enter your choice: '
INVALID_OPTION='Invalid option'

DEBAIN='Debain'
UBUNTU='Ubuntu'
POP_OS='Pop_OS'
FEDORA='Fedora'
MANJARO='Manjaro'

has_apt() {
  [ -x "$(command -v apt)" ]
}

has_dnf() {
  [ -x "$(command -v dnf)" ]
}

has_pacman() {
  [ -x "$(command -v pacman)" ]
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

  if [ -x "$(command -v flatpak)" ]; then
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

  if [ -x "$(command -v flatpak)" ]; then
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
  local options=("Back" "System Package Querying" "Flatpak Package Querying")
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
  echo "Function needs implementing"
}

find_remote_system_package() {
  echo "Function needs implementing"
}

list_all_installed_system_packages() {
  echo "Function needs implementing"
}

list_all_remote_system_packages() {
  echo "Function needs implementing"
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
  echo "Function needs implementing"
}

uninstall_flatpak_package() {
  echo "Function needs implementing"
}

find_installed_flatpak_package() {
  echo "Function needs implementing"
}

find_remote_flatpak_package() {
  echo "Function needs implementing"
}

list_all_installed_flatpak_packages() {
  echo "Function needs implementing"
}

list_all_remote_flatpak_packages() {
  echo "Function needs implementing"
}

system_recovery() {
  echo "Function needs implementing"
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
