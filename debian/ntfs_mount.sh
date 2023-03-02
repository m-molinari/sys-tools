#!/bin/bash
#

USERNAME=$1
PARTITION=$2

if [ -z $USERNAME ] || [ -z $PARTITION ]; then
    echo "usage $0 user /dev/sdX" 
    exit 1
fi

if [ $(sudo getent passwd ${USER}| grep -c ^${USER}:) -eq 0 ]; then
    echo "User : $USERNAME doesn't exist on system"
    exit 1
fi

if [ $(sudo blkid | grep ${PARTITION}:  | grep -Eoc 'TYPE="ntfs"') -eq 0 ] ; then
    echo "partition $PARTITION doesn't found on system"
    exit 1
fi

USER_UID=$(sudo getent passwd ${USERNAME} | grep -Eo ":[0-9]{4}:" | sed 's/://g')

sudo apt update

sudo apt install ntfs-3g 

sudo mkdir -p /media/${USERNAME}/dati/

sudo chown ${USERNAME}:${USERNAME} /media/${USERNAME}/dati/

MY_UUID=$(sudo blkid | grep /dev/sda4:   |  grep -Eo ' UUID=".*" ' | awk '{print $1}' | sed 's/"//'g)

sudo cp -a /etc/fstab $HOME/fstab.orig

echo "" | sudo tee -a  /etc/fstab
echo "# Partition NTFS" | sudo tee -a  /etc/fstab
echo "${MY_UUID}	/media/${USERNAME}/dati	 ntfs-3g 	permissions,defaults 0 0" | sudo tee -a /etc/fstab

