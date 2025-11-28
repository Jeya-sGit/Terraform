#!/bin/bash
yum update -y
yum install -y httpd
Systemctl start httpd
systemctl enable httpd
echo "<h1>This message from yt webserver: $(hostname -1)</h1>> /var/www/html/index.html