#!/bin/sh
yum install httpd -y
echo "Dummy landing page on host " > /var/www/html/index.html
hostname >> /var/www/html/index.html
sed -i 's/^Listen 80$/Listen 8000/' /etc/httpd/conf/httpd.conf
systemctl enable httpd
systemctl start httpd