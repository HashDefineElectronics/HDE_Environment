#!/bin/bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='zattaz#'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

#add the vagrant user to this groups
usermod -a -G dialout vagrant
usermod -a -G video vagrant
usermod -a -G plugdev vagrant

sudo userdel ubuntu
sudo rm -r /home/ubuntu
sudo apt-get -y install ubuntu-desktop
sudo apt-get -y install kicad
sudo apt-get -y install linux-image-extra-virtual
sudo apt-get -y install putty
sudo apt-get -y install doxygen
sudo apt-get -y install doxygen-gui
sudo apt-get -y install graphviz
sudo apt-get -y install meld
sudo apt-get -y install curl
sudo apt-get -y install wget
sudo apt-get -y install libftdi-dev
sudo apt-get -y install linux-headers-generic build-essential dkms

# Install guake
sudo apt-get -y install guake

#install the guest addition
wget http://download.virtualbox.org/virtualbox/5.0.10/VBoxGuestAdditions_5.0.10.iso
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro VBoxGuestAdditions_5.0.10.iso /media/VBoxGuestAdditions
sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run
rm VBoxGuestAdditions_5.0.10.iso
sudo umount /media/VBoxGuestAdditions
sudo rmdir /media/VBoxGuestAdditions

mkdir ~/.config/autostart

#Make the guake auto startup
GUAKE_STARTUP_FILE=$(cat <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/bin/guake
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en]=Guake
Name=Guake
Comment[en]=Terminal
Comment=Terminal
EOF
)

echo "${GUAKE_STARTUP_FILE}" > ~/.config/autostart/guake.desktop

#Change the system keyboard to uk gb
setxkbmap -layout gb

sudo reboot