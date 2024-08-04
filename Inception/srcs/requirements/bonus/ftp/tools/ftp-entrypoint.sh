#!/bin/sh
if [ ! -f "/etc/vsftpd/vsftpd.conf.bak" ]; then

        mkdir -p /var/www/html
        cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.bak
        mv /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf

        # ADD ftp user, change the password and give the ownershipf of wordpress folder recursively
        adduser $FTP_USER --disabled-password
        echo "$FTP_USER:$FTP_PASSWORD" | chpasswd &> null
        chown -R $FTP_USER /var/www/html
        echo $FTP_USER | tee -a /etc/vsftpd.userlist &> /dev/null
fi
echo "FTP started on :21"
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf