#!/bin/bash

echo 'Checking for existing installation...'

expectedFolderForExistingDainaInstallation="${HOME}/Daina"
if [ -d "$expectedFolderForExistingDainaInstallation" ]; then
	echo "Found existing installation: $expectedFolderForExistingDainaInstallation"
	read -p "Remove existing installation and continue? ('y' = yes, 'n' = no) " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
    		[[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
	fi
	sudo rm -R "$expectedFolderForExistingDainaInstallation"
else
	echo 'No existing installation found.'
fi

currentVersionOfDaina=$(wget -O - 'https://raw.githubusercontent.com/SamuelWhitton/daina/master/current_version')

echo "Downloading current version: $currentVersionOfDaina..."

wget -O "${currentVersionOfDaina}.tar" "https://raw.githubusercontent.com/SamuelWhitton/daina/master/${currentVersionOfDaina}.tar"

tar -xf "${currentVersionOfDaina}.tar"

if [ -d "${currentVersionOfDaina}" ] && [ -e "${currentVersionOfDaina}.tar" ]; then
	cd "${currentVersionOfDaina}"
	sudo "./install.pl"
	sudo sh -c "echo '${currentVersionOfDaina}' > '${expectedFolderForExistingDainaInstallation}/version'"
	cd ../
	echo 'Cleaning up...'
	sudo rm -R "$currentVersionOfDaina"
	rm "${currentVersionOfDaina}.tar"
	echo 'Done.'
else
	echo "Problem downloading or extracting ${currentVersionOfDaina}.tar"
fi



