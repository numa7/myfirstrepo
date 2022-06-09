#!/bin/bash

set -e # Exit script immediately on first error.

#update sys
echo "Update.. "
sudo apt update -y && sudo apt upgrade -y

#asking 
read -p 'Wish to install phpMyAdmin? (y to install, 
other or leave empty to cancel)
' MYCHOICE
 if [[ $MYCHOICE = "y" ]]
   then 
    echo "
    ---------------------
    Install phpMyAdmin
    ---------------------
    "
    sudo apt -y install wget php php-cgi php-mysqli php-pear php-mbstring libapache2-mod-php php-common php-phpseclib php-mysql
    echo "
    ---------------------
    1st step OK
    Install apache2...
    ---------------------
    "
    sudo apt -y install wget apache2
    echo "
    ---------------------
    2nd step OK
    Install phpmyadmin...
    ---------------------
    "
    
    sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl
    #crea or generate pass for phpmyadm
    read -p '
    Enter new secret passphrase or leave empty to generate new:
    ----------------------------------------
    ' PHPPSSWD
     if [[ $PHPPSSWD = "" ]]
       then 
         echo "generaete new"
         PHPPSSWD=`openssl rand -base64 12`
         echo $PHPPSSWD
         sleep 3s
     else 
       echo "new passphrs successfully added
    ----------------------------------------
    $PHPPSSWD
    ----------------------------------------"
       
       sleep 2s
     fi

    sudo systemctl restart apache2

    echo "
    ---------------------
    
    phpmyadm pswd: $PHPPSSWD
    ---------------------"
  else
    echo "
    ---------------------
    ok...    :-(
    ---------------------
    "
 fi   
