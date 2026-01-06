#!/bin/bash
exec > /var/log/user-data.log 2>&1
yum update -y
yum install httpd -y
systemctl start httpd 
systemctl enable httpd 
echo "<h1>Hello from $(hostname -f) - Deployed via Terraform</h1>" > /var/www/html/index.html