Backup Mikrotik
-------------------------------------------------
Script written by:<br>
Jorge Luiz Taioque<br>
jorgeluiztaioque at gamil dot com<br>

This script allows make backups of Mikrotik devices and restore without change anything on device.<br>
The principal function is restore all wireless configuration without change mac adress of wireless or<br>
ethernet interface.<br>

- put all mikritk IP in file ips.txt (all of theses ips script will do the backup)

-After did all backup the script send all files to a remote ftp server

Usage:<br>
./backup-mikrotik.sh [user-mk] [pass-mk] [ip--ftp-server] [user-ftp] [pass-ftp]

