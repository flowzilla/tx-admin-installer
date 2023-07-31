#    Copyright (C) 2021  FlowZilla.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License 2 as published by
#    the Free Software Foundation.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License 2 for more details.
#
#    You should have received a copy of the GNU General Public License 2 along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

#!/bin/bash


datenbank() {
  clear
  bash <(curl -s https://raw.githubusercontent.com/JulianGransee/PHPMyAdminInstaller/main/install.sh)

}




tx_options(){
    
    echo -e This Script made by FlowZilla. https://github.com/flowzilla PHPMyAdmin install script by Julian G. https://github.com/JulianGransee
    echo -e  Please select your option:
    echo -e  [1] TxAdmin Newest Version with Database/PHPMyAdmin
    echo -e  [2] Only TxAdmin. Newest Version
    read -r choice
    case $choice in
        1 ) txoption=1

            ;;
        2 ) txoption=2
        
            ;;   
        * ) 
            tx_options
    esac
}





txadmin() { 
  echo -e https://github.com/flowzilla/tx-admin-installer
 
  sleep 20

  cd /home/

  string=`wget -qO- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | egrep -m 3 -o "............................................./*\/fx.tar.xz"`
  
	newstring=$( echo $string | cut -c113- )

  wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$newstring

  tar -Jxvf fx.tar.xz

  rm -r fx.tar.xz

  clear

  ./run.sh +set serverProfile dev_server +set txAdminPort 40120

}


 if [ "$EUID" -ne 0 ]; then
        echo "Please run as root."
        exit 3
    fi

tx_options

case $txoption in 
        1) datenbank
           echo -e This is you Database Data. Please save it, you have 20s
           txadmin
             ;;
        2) txadmin
             ;;
esac
