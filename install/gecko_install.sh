#!/bin/bash
# download and install latest geckodriver for linux or mac.
# required for selenium to drive a firefox browser.

json=$(curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest)
if [[ $(uname) == "Darwin" ]]; then
    url=$(echo "$json" | jq -r '.assets[].browser_download_url | select(contains("macos"))')
elif [[ $(uname) == "Linux" ]]; then
    url=$(echo "$json" | jq -r '.assets[].browser_download_url | select(contains("linux64"))')
else
    echo "can't determine OS"
    exit 1
fi

if [[ -z "${DEPLOY_ENV}" ]]; then
    install_dir="/usr/local/bin"
    curl -s -L "$url" | tar -xz
    chmod +x geckodriver
    sudo mv geckodriver "$install_dir"
    echo "installed geckodriver binary in $install_dir"

else
    install_dir="/home/circleci/project"
    curl -s -L "$url" | tar -xz
    chmod +x geckodriver
    sudo mv geckodriver "$install_dir"
    echo "installed geckodriver binary in $install_dir"
fi
