#!/bin/bash
# Mikrotik Backup 
# Jorge Luiz Taioque
# jorgeluiztaioque at gmail dot com


#Receiving all variables
ipmk=$1
user=$2
senha=$3


#Begning script 

echo "################################################" >> backup.txt
echo "#  Backup Mikrotik" >> backup.txt
echo "#  Jorge Luiz Taioque" >> backup.txt
echo "#  jorgeluiztaioque at gmail dot com" >> backup.txt
echo "#  Backup Realizado  $( date +%H:%M___%d-%m-%Y)" >> backup.txt
echo "#  Mikrotik IP = $ipmk" >> backup.txt
echo "#" >> backup.txt
echo "################################################" >> backup.txt
echo " " >> backup.txt
echo " " >> backup.txt

#Extracting MACs and Radio-name of all interfaces (Supports until 10 wireless interfaces and 4 ethernet
timeout 40 ./sshpass -p $senha ssh -oConnectTimeout=10 -oStrictHostKeyChecking=no $ipmk -l $user ":put [/in wi get 0 mac-address]; 
:put [/in wi get 1 mac-address]; 
:put [/in wi get 2 mac-address]; 
:put [/in wi get 3 mac-address]; 
:put [/in wi get 4 mac-address]; 
:put [/in wi get 5 mac-address]; 
:put [/in wi get 6 mac-address]; 
:put [/in wi get 7 mac-address]; 
:put [/in eth get 0 mac-address ];
:put [/in eth get 1 mac-address ]; 
:put [/in eth get 2 mac-address ]; 
:put [/in eth get 3 mac-address ]; 
:put [/in wi get 0 radio-name]; 
:put [/in wi get 1 radio-name]; 
:put [/in wi get 2 radio-name]; 
:put [/in wi get 3 radio-name]; 
:put [/in wi get 4 radio-name]; 
:put [/in wi get 5 radio-name]; 
:put [/in wi get 6 radio-name]; 
:put [/in wi get 7 radio-name]; 
:put [/in wi get 8 radio-name]" > mac.sh


#Extracting all mikrotik configuration
timeout 40 ./sshpass -p $senha ssh -oConnectTimeout=10 -oStrictHostKeyChecking=no $ipmk -l $user "export;"  >> backup.txt
 
 
#Removing spaces mac file
sed -e 's/.$//' mac.sh >mac2.sh;


#Filtring MAC Address 
#Here script remove all mac addres in orther to don't clone interfaces mac when backups are retorned
for imac in $(cat mac2.sh); do
sed -e  's/'$imac'//' backup.txt > backup1.txt;
outmac=mac-addres=$imac;
sed -e  's/'$outmac'//' backup1.txt > backup.txt;
sed -e  's/mac-address=//' backup.txt > backup1.txt;
sed -e  's/radio-name=//' backup1.txt > backup.txt;
done
 

#Adding admin username and enalbe API
echo "/;"  >> backup.txt
echo "/user set admin password=$senha" >> backup.txt
echo "/ip service enable api;" >> backup.txt
echo "####################" >> backup.txt
echo "#----END-SCRIPT----#" >> backup.txt
echo "####################;" >> backup.txt


#Change backup name
mv backup.txt mk-$ipmk-backup.txt


#Move backup to foder
mv mk-$ipmk-backup.txt backup-mk

#Delete temporary files
rm -r backup1.txt
rm -r mac.sh
rm -r mac2.sh
