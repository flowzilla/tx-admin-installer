#!/bin/bash

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

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root."
    exit 1
fi

install_database() {
    clear
    echo "Installing PHPMyAdmin and database..."
    bash <(curl -s https://raw.githubusercontent.com/JulianGransee/PHPMyAdminInstaller/main/install.sh)
    echo "Database and PHPMyAdmin installed successfully!"
    sleep 2
}

display_options() {
    echo -e "\nScript created by V01D: https://github.com/flowzilla"
    echo -e "PHPMyAdmin install script by Julian G.: https://github.com/JulianGransee\n"
    echo "Please choose an option:"
    echo "  [1] Install TxAdmin with Database and PHPMyAdmin"
    echo "  [2] Install only TxAdmin (Latest Version)"
    read -p "Enter your choice: " choice
    case $choice in
        1) return 1 ;;
        2) return 2 ;;
        *) 
            echo "Invalid option, please try again."
            display_options
            ;;
    esac
}

install_txadmin() {
    echo "Installing the latest version of TxAdmin..."
    cd /home/ || exit 1

    latest_version=$(wget -qO- https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/ | grep -m 1 -oP 'fx\.tar\.xz(?=\")')

    if [[ -z $latest_version ]]; then
        echo "Failed to retrieve the latest version of TxAdmin. Exiting."
        exit 1
    fi

    wget "https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/$latest_version" -O fx.tar.xz
    tar -Jxvf fx.tar.xz
    rm -r fx.tar.xz

    echo "TxAdmin installed successfully. Starting the server..."
    sleep 2
    clear

    ./run.sh +set serverProfile dev_server +set txAdminPort 40120
}

main() {
    display_options
    option=$?

    if [[ $option -eq 1 ]]; then
        install_database
        echo "Here are your database details. Please save them, you have 20 seconds."
        sleep 20
        install_txadmin
    elif [[ $option -eq 2 ]]; then
        install_txadmin
    fi
}

main