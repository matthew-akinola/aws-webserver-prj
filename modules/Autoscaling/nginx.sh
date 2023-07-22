#!/bin/bash
yum install -y nginx
systemctl start nginx
systemctl enable nginx
git clone git https://github.com/matthew-akinola/ACS-project.git
mv /ACS-project-config/reverse.conf /etc/nginx/
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-distro
cd /etc/nginx/
touch nginx.conf
sed -n 'w nginx.conf' reverse.conf
systemctl restart nginx
rm -rf reverse.conf
rm -rf /ACS-project-config