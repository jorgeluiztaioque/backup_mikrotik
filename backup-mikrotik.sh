#!/bin/bash
# Mikrotik Backup 
# Jorge Luiz Taioque
# jorgeluiztaioque at gmail dot com

user=$1
pass=$2

#creating a folder to store backups
mkdir backup-mk;

command="$user $pass"


for i in $(cat ips.txt); do
	./mk.sh $i $command
done

zip -r backup-mk.zip backup-mk
mv backup-mk.zip backup-mk/

cd backup-mk/
########################################
#SEND BACKUP TP FTP SERVER
# DON'T FORGOT TO CREATE A FOLTHER WITH mk NAME
########################################
sleep 1;
SERVER=$3
USER=$4
PASS=$5 

ftp -n -n -p -i $SERVER <<END_SCRIPT
user $USER $PASS
binary
cd mk
cd mikrotiks
mdelete *.txt
rename backup-mk.zip backup-mk.zip2
mdelete *.zip
mput *.txt
mput *.zip
rename backup-mk.zip2 backup-mk-ant.zip
mget backup-mk-ant.zip
quit
END_SCRIPT
