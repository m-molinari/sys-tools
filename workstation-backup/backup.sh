#!/bin/bash
#

# Get user 1000, the best
USERF=$(grep :1000 /etc/passwd | cut -d ":" -f1)

# Create folder BACKUP
#
[ ! -d $HOME/BACKUP ] && mkdir -p $HOME/BACKUP 

echo

# Save dconf settings
#
dconf dump / > $HOME/BACKUP/dconf_backup

# Restore
# dconf load / < $HOME/BACKUP/dconf_backup

if [ $? -gt 0 ]; then
    echo "ERROR while saving dconf settings"
    exit 1
    echo
else
    echo "dconf settings saved"
    echo
fi

# Save gsettings settings
#
gsettings list-recursively > $HOME/BACKUP/gsettings

if [ $? -gt 0 ]; then
    echo "ERROR while saving gsettings settings"
    exit 1
    echo
else
    echo "dconf settings saved"
    echo
fi

# tar etc
#
sudo tar jcf $HOME/BACKUP/etc.tar.bz2 /etc
chown $USERF:$USERF $HOME/BACKUP/etc.tar.bz2

if [ $? -gt 0 ]; then
    echo "ERROR while tar etc"
    exit 1
    echo
else
    echo
    echo "etc compressed and saved :"
    ls -lh $HOME/BACKUP/etc.tar.bz2
fi

echo
echo "Save this folder: $HOME/BACKUP on external storage"
echo
