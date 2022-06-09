#!/bin/bash



set -e # Exit script immediately on first error.

#update sys
echo "Update.. "
sudo apt update -y && sudo apt upgrade -y

#MySQL passw making
sudo apt -y install openssl
read -p 'Enter MySQL username:
' MYSQLUSR
read -p 'Enter MySQL password or leave empty to generate new:
' MYSQLPSSWD
 if [[ $MYSQLPSSWD = "" ]]
   then 
     echo "generaete new
-------------------"
     MYSQLPSSWD=`openssl rand -base64 12`
     echo $MYSQLPSSWD
     sleep 3s
 else 
   echo "new passwd for $MYSQLUSR successfully added
----------------------------------------
$MYSQLPSSWD
----------------------------------------"
   
   sleep 2s
 fi
echo "-------------------" 


#add deb repo
sudo apt install wget -y
sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.20-1_all.deb

# Install the release package
sudo dpkg -i mysql-apt-config*


# Install MySQL
sudo apt update -y
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
sudo apt update -y && sudo apt upgrade -y
sudo apt install mysql-server -y
sudo mysql_secure_installation
echo "
---------------------
installed!
---------------------"
sleep 1s
echo "MySQL Password for $MYSQLUSR set to
------------------------
$MYSQLPSSWD
------------------------"
sudo service mysql restart
sleep 1s

# create random password
#PASSWDDB="$(openssl rand -base64 12)"

# replace "-" with "_" for database username
#MAINDB=${USER_NAME//[^a-zA-Z0-9]/_}

# If /root/.my.cnf exists then it won't ask for root password
if [ -f /root/.my.cnf ]; then

#    mysql -e "CREATE DATABASE $MYSQLUSR /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    sudo mysql -e "CREATE USER $MYSQLUSR@localhost IDENTIFIED BY '$MYSQLPSSWD';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON $MYSQLUSR.* TO '$MYSQLUSR'@'localhost';"
    sudo mysql -e "FLUSH PRIVILEGES;"

# If /root/.my.cnf doesn't exist then it'll ask for root password   
else
    read -p 'Creating mysql user 
    Please enter root user MySQL password!
    (you made it few minutes ago)
    ' rootpasswd
    sudo mysql -uroot -p${rootpasswd} -e "CREATE DATABASE $MYSQLUSR /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    echo "db created.."
    sudo mysql -uroot -p${rootpasswd} -e "CREATE USER $MYSQLUSR@localhost IDENTIFIED BY '$MYSQLPSSWD';"
    echo "user $MYSQLUSR created "
    sudo mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON $MYSQLUSR.* TO '$MYSQLUSR'@'localhost';"
    echo "privs for $MYSQLUSR added"
    sudo mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
    echo "privs flushed"
fi

sleep 1s
###################
#                 #
# Install myAdmin #
#                 #
###################

#asking 
read -p 'Wish to install phpMyAdmin? (y to install, 
other or leave empty to continue)
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
    $MYSQLUSR pass $MYSQLPSSWD
    phpmyadm $PHPPSSWD
    ---------------------"
  else
    echo "
    ---------------------
    mysql user $MYSQLUSR
    mysql pass $MYSQLPSSWD
    ---------------------"
 fi   
