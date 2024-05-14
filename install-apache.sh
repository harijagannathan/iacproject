#!/bin/bash
sudo yum update
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
echo "<h1> Server Name - $(hostname -f)</h1>" > /var/www/html/index.html