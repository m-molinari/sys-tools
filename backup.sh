#!/bin/bash

#
# Backup Script (best use with cron)
#

# Declare variables
TIME=`date +%Y-%m-%d`
HOSTNAME=$(hostname)
OLD_BACKUP=0
BACKUPTIME=`date +%Y%m%d-%H%M`
MY_TAR=`which tar`
MY_FIND=`which find`

# Usage
usage() {
        echo "Usage: $0 [OPTION ...]"
        echo
        echo "Examples:"
        echo "$0 [-s <source dir>] [-d <destination dir>] [-n <backup name file>] [-r <backup retention>] [-v (optional)]"
        echo
        echo "Arguments:"
        echo "-s source dir to backup (must)"
        echo "-d destination dir where backup will be stored (must)"
        echo "-n name of backup file (must)"
        echo "-r retention how many days backups will be keep (must)"
        echo "-v verbose (optional)"
        echo
        exit 1
}

# Getops
while getopts ":s:d:n:r:h:v" opt; do
    case "${opt}" in
        s)
            SRCDIR=${OPTARG}
            ;;
        d)
            DESDIR=${OPTARG}
            ;;
	n)
            NAME=${OPTARG}
            ;;
	r)
            RET=${OPTARG}
            ;;
	h)
            usage
            ;;
	v)
            VERBOSE=1
            ;;
        *)
            usage
            ;;
    esac
done

# Must arguments
if [ -z $SRCDIR ] || [ -z $DESDIR ] || [ -z $NAME ] || [ -z $RET ]; then
	usage
	exit 1
fi

# Testing and creating destination directory
if [ ! -d "$SRCDIR" ]; then
        echo "Missing source directory on filesystem"
        echo "Backup failed"
        exit 1
fi

# Testing and creating destination directory
if [ ! -d "$DESDIR" ]; then
        echo "Missing destination directory on filesystem"
        echo "Backup failed"
        exit 1
fi

# Test read permission
if [ ! -r $SRCDIR ] ; then
	echo "You haven't read permission on $SRCDIR"
	exit 1
fi

# Find old backups
OLD_BACKUP=$($MY_FIND $DESDIR -name "${HOSTNAME}-${NAME}*.tar.gz" -mtime +${RET} | wc -l)

# If old backups are more then retention delete it
if [ $($MY_FIND $DESDIR -type f -name "${HOSTNAME}-${NAME}-*.tar.gz"| wc -l) -gt $RET ] ; then
	$MY_FIND $DESDIR -name "${HOSTNAME}-${NAME}-*.tar.gz" -mtime +${RET} -delete
	echo "Removed old $OLD_BACKUP backups"
fi

# Start backup message
echo
echo "Starting backup of $SRCDIR to $DESDIR with date: $TIME"
echo

# If exist -v arg tar will have verbose command
if [ "$VERBOSE" == "1" ] ; then
	$MY_TAR -cvzf $DESDIR/${HOSTNAME}-${NAME}-${BACKUPTIME}.tar.gz $SRCDIR 2>&1 >/dev/null  
else
	$MY_TAR -czf  $DESDIR/${HOSTNAME}-${NAME}-${BACKUPTIME}.tar.gz $SRCDIR 2>&1 >/dev/null
fi

if [ $? -gt 0 ]; then
    echo "Backup Failed"
    exit 1
fi

echo
echo "Backup finished, check it on $DESDIR"
exit 0
