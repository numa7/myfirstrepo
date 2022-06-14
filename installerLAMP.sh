#!/bin/bash

set -e # Exit script immediately on first error.

OS=`lsb_release -c`
MYSQLPSSWD=$2
MYSQLUSR=$1
echo "
-------------------
scr will install
MariDB with
user: $MYSQLUSR
passwd: $MYSQLPSSWD

-------------------"
sleep 1s
  if echo "$OS" | grep -q 'bullseye' > /dev/null 2>&1
   then
     echo "
     -----------------
     your system is OK..
     $OS
     -----------------"
     sleep 1s
          
     #update sys
     echo "Update.. "
     sudo apt update -y && sudo apt upgrade -y
     
      #MySQL passw making
      if  [[ $MYSQLUSR != "" ]]
        then
        sudo apt -y install openssl
         if [[ $MYSQLPSSWD = "" ]]
           then 
             echo "generate new psswd
        -------------------"
             MYSQLPSSWD=`openssl rand -base64 12`
             echo $MYSQLPSSWD
             sleep 3s
           else 
             echo "----------------------------------------
             MariaDB will be installed with
             user: $MYSQLUSR
             pass: $MYSQLPSSWD
             ----------------------------------------"
             sleep 2s
         fi
        else
         echo "
         ----------------------------
         MariaDB will be installed
          with default user/pass
         ----------------------------" 
         sleep 1s
     fi   
     #
     sudo apt install curl
     echo "-------------------
     curl installed
     --------------------"
     sleep 1s
     curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash
     echo "-------------------
     Maria downloaded
     --------------------"
     sleep 1s
     sudo apt-get install mariadb-server mariadb-client mariadb-backup -y
     echo "-------------------
     Maria installed
     --------------------"
     sleep 2s
    
     sudo service mysql restart
     sleep 2s     
         
#         if  [[ $MYSQLUSR = "" ]]
#           then
#             echo "-------------------
#             default params
#             --------------------"
#           else 
#             sudo mysql -u root
#             CREATE USER '$MYSQLUSR'@localhost IDENTIFIED BY '$MYSQLPSSWD';
#             GRANT ALL PRIVILEGES ON *.* TO '$MYSQLUSR'@localhost IDENTIFIED BY '$MYSQLPSSWD';
#             FLUSH PRIVILEGES;
#             echo "-------------------
#             with
#             user: $MYSQLUSR
#             pass: $MYSQLPSSWD
#             --------------------"
#         fi  
 
  else       
    echo "    ---------------------
    system not supported...
    script for deb11 bullseye only
    -------------------------"
    sleep 3s
    exit
  fi
    