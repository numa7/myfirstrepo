#!/bin/bash

###############################
# MySQL Server dependencies #
###############################

# The latest source code can be found at https://gist.github.com/rponte/7561856

set -e # Exit script immediately on first error.
#set -x # Print commands and their arguments as they are executed.

echo "Update.. "
sudo apt update -y && sudo apt upgrade -y #update sys

#MySQL passw making
sudo apt -y install openssl
read -sp 'Enter MySQL password or leave empty to generate new: ' MYSQLPSSWD
 if [[ $MYSQLPSSWD = "" ]]
   then 
     echo "generaete new"
     MYSQLPSSWD=`openssl rand -base64 12`
     echo $MYSQLPSSWD
     sleep 3s
 else 
   echo "new passwd successfully added
----------------------------------------"
   
   sleep 2s
 fi
echo "_____________________________" 

# Check if MySQL environment is already installed
#RUN_ONCE_FLAG=~/.mysql_env_build_time
#MYSQL_PASSWORD="root"

#if [ -e "$RUN_ONCE_FLAG" ]; then
#  echo "MySQL Server environment is already installed."
#  exit 0
#fi

#add deb repo
sudo apt install wget -y
wget https://dev.mysql.com/get/mysql-apt-config_0.8.20-1_all.deb

# Installs MySQL 5.7
sudo apt install ./mysql-apt-config_*_all.deb -y

# Configures MySQL
#sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
#sudo sed -i '/\[mysqld\]/a\lower_case_table_names=1' /etc/mysql/my.cnf
echo "MySQL Password set to '$MYSQLPSSWD'. Remember to delete ~/.mysql.passwd" | tee ~/.mysql.passwd; 
mysql -uroot -p$MYSQLPSSWD -e "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;";
sudo service mysql restart

# Installs basic dependencies
sudo apt install -y unzip git curl

# Configures prompt color
sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' ~/.bashrc
echo 'source ~/.bashrc' >> ~/.bash_profile
source ~/.bash_profile

# Cleaning unneeded packages
sudo apt-get autoremove -y
sudo apt-get clean

# sets "run once" flag
date > $RUN_ONCE_FLAG