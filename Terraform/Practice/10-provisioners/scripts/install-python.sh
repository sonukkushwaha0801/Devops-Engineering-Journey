#!/bin/bash

if command -v python3 >/dev/null 2>&1; then
    echo "Python3 already installed. Upgrading..."
    sudo apt update -y
    sudo apt install --only-upgrade python3 -y

else
    echo "Installing Python3..."
    sudo apt update -y
    sudo apt install python3 -y
fi

python3 --version
