#!/bin/bash

if command -v nginx >/dev/null 2>&1
then
    echo "NGINX already installed. Upgrading..."
    sudo apt update -y
    sudo apt install --only-upgrade nginx -y

else
    echo "Installing NGINX..."
    sudo apt update -y
    sudo apt install nginx -y
fi

sudo systemctl enable nginx
sudo systemctl restart nginx
nginx -v
