DEBAIN='Debain'
UBUNTU='Ubuntu'
POP_OS='Pop_OS'
FEDORA='Fedora'
MANJARO='Manjaro'

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
  OPERATING_SYSTEM=echo cat /etc/*-release | grep "pretty_name" --ignore-case
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

update_system() {
  echo "Updating System"

  if [ -x "$(command -v flatpak)" ]; then
    sudo flatpak update
  fi
  if [ -x "$(command -v apt)" ]; then
    sudo apt update
    sudo apt upgrade
    return
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf update
    return
  elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Syyu
    return
  fi
}

cleanup_system() {
  echo "Cleaning System"

  if [ -x "$(command -v flatpak)" ]; then
    sudo flatpak uninstall --unused --delete-data
  fi
  if [ -x "$(command -v apt)" ]; then
    sudo apt autopurge
    sudo apt autoclean
    return
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf autoremove
    sudo dnf clean all
    return
  elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Rs
    return
  fi
}

system_management() {
  local PS3='Please enter your choice: '
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
      #        upgrade_system_to_next_release
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}

main() {
  display_os_welcome_message

  PS3='Please enter your choice: '
  options=("Quit" "OS Management" "OS Package Query" "OS Recovery")
  select opt in "${options[@]}"; do
    case $opt in
    "Quit")
      break
      ;;
    "OS Management")
      system_management
      ;;
    "OS Package Query")
      #        package_query
      ;;
    "OS Recovery")
      #        system_recovery
      ;;
    *) echo "Invalid option $REPLY" ;;
    esac
  done
}

main