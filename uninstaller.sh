#!/bin/bash

sudo service mysql stop
sudo killall -KILL mysql mysqld_safe mysqld
sudo apt-get --yes purge mysql-server mysql-client
sudo apt-get --yes autoremove --purge
sudo apt-get autoclean
sudo deluser --remove-home mysql
sudo delgroup mysql
sudo rm -rf /etc/apparmor.d/abstractions/mysql /etc/apparmor.d/cache/usr.sbin.mysqld /etc/mysql /var/lib/mysql /var/log/mysql* /var/log/upstart/mysql.log* /var/run/mysqld
sudo updatedb

echo "remove apache2.."
sudo apt remove apache2 -y
echo "done"
sleep 1s
echo "remove php-mysql.."
sudo apt remove php-mysql -y
sudo apt remove php-mbstring -y
echo "done"
sleep 1s
echo "remove Maria..."
sudo apt  remove  mariadb-server mariadb-client mariadb-backup -y

echo "done"
sleep 1s
echo "remove mysql-server.."
sudo apt remove mysql-server -y
echo "done"
sleep 1s
echo "remove mysql-apt-config.."
sudo apt remove mysql-apt-config -y
echo "done"
sleep 1s
echo "deleting downloaded files.."
sudo rm -f mysql-apt-config_*
sudo rm -f phpMyAdmin-*
sudo rm -f /etc/apt/sources.list.d/mariadb.list*
echo "done"
sleep 1s
