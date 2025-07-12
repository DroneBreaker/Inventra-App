#!/bin/bash
# Use this for your user data (script from top to bottom)
#install httpd (Linux v2)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Welcome to the INVENTRA Server and listening from $(hostname -f)</h1>" > /var/www/html/index.html