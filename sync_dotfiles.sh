#!/bin/bash

if [ -z $1 ] ; then
	echo -e "\033[0;31m missing dotfiles repo path \033[0m"
	exit 1 
fi

REPO_PATH=$1

if  [ -e /etc/debian_version ] ; then
	DISTRO=debian
elif [ -e /etc/arch-release ] ; then
	DISTRO=archlinux
elif [ -e /etc/gentoo-release  ] ; then
        DISTRO=gentoo
else
	echo -e "\033[0;31m distro not found \033[0m"  
	exit 1
fi

if  [ ! -d $REPO_PATH/dotfiles/  ] ; then
	echo -e "\033[0;31m repo not found in: $REPO_PATH \033[0m"
	exit 1
fi

cd $REPO_PATH/dotfiles/ && git pull

if [ "$2" == "dry" ] ; then
	rsync -avz --dry-run --ignore-existing --include ".*" $DISTRO/ --exclude .git --exclude README.md  $HOME/
else
	rsync -avz --ignore-existing --include ".*" $DISTRO/ --exclude .git --exclude README.md  $HOME/
fi

echo 
echo -e  "\033[0;32m sync $DISTRO config \033[0m"
echo

exit 0
