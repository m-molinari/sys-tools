#! /usr/bin/env python3
# vim: set tabstop=4 shiftwidth=4 softtabstop=4 expandtab autoindent
# -*- coding: utf-8 -*-

"""
Simple exercise for improving python skills
This script do a backup of a folder source to a destination folder by tar and save list of packages 
Note: this script will work only in Debian OS or derivates
"""

import os, sys, socket, logging
import re
from datetime import datetime
import tarfile
import time
import argparse

# Check if OS is Debian based
if os.path.isfile("/etc/debian_version") is False:
    print("Sorry this script work only on Debian OS ...")
    sys.exit(2)

# Declare arguments
parser = argparse.ArgumentParser(description='Backup Arguments')
parser.add_argument("-s", "--sourcedir", type=str, help="What you want backup", required=True)
parser.add_argument("-d", "--destdir", type=str, help="Where you want save backup", required=True)
parser.add_argument("-r", "--retention", type=int, help="How many days to keep", required=True)
parser.add_argument("-c", "--clean", type=str, help="Delete old backups", default="")
parser.add_argument("-l", "--log", type=str, help="Where log backup process", default="/var/log/syslog")
parser.add_argument("-v", "--verbose", type=bool, help="Print some process to stdout", default=False)
parser.add_argument

# Parse arguments variables
args = parser.parse_args()
SRCDIR = args.sourcedir
DESTDIR = args.destdir
LOGSYS = args.log
DELETE = args.clean
VERBOSE = args.verbose

# Inizialidze logging
logging.basicConfig(filename=LOGSYS, level=logging.INFO)

# Constant variables
SRCNAME = SRCDIR.replace("/" , "")
PACKAGE = "/packages.txt"
now = datetime.now()
MYTIME = datetime.today()
HOSTNAME = socket.gethostname()
BACKUPTIME = now.strftime("%Y%m%d-%H%M")
DESPKG = DESTDIR + PACKAGE
UID = os.getuid()

# Create Backup destination folder passed
if not os.path.exists(DESTDIR):
    try:
        os.makedirs(DESTDIR)
    except FileExistsError:
        print("File already exists")
        sys.exit(2)

# Logging INFO backup to log file
logging.info("Starting backup of %s to %s at %s"  % (SRCDIR, DESTDIR, MYTIME))

# Saving list of packages installed on system
try:
    os.system("dpkg -l > %s" % DESPKG)
except:
    logging.error("Something goes wrong in package list save")
    sys.exit(2)

# Backup with tar of src dir
try:
    with tarfile.open(DESTDIR + HOSTNAME + '-' + SRCNAME + '-' + BACKUPTIME + '.tar.gz', mode='w:gz') as archive:
        archive.add(SRCDIR, recursive=True)
except:
    logging.error("Something goes wrong in tar process")
    sys.exit(2)

# Retention, number days to keep
RETENTION = 5
os.chdir(os.path.join(os.getcwd(), DESTDIR))
list_of_files = os.listdir()
current_time = time.time()
day = 86400
count = 0

# Get number of backup saved
try:
    for files_check in list_of_files:
        file_location = os.path.join(os.getcwd(), files_check)
        if files_check.startswith(HOSTNAME + '-' +  SRCNAME) and files_check.endswith('gz'):
            # If Verbose is True list existent files
            if VERBOSE is True :
                print(files_check)
            count+=1
except:
    logging.error("Something goes wrong in check old backup")
    sys.exit(2)

print ("Found " + str(count) + " old backups\n")

# If there are at least 2 backup saved, we delete older than retention days
if count > 2:
    for backup_files in list_of_files:
        # If Verbose i True show list of files
        if VERBOSE is True:
            print (backup_files)
        file_location = os.path.join(os.getcwd(), backup_files)
        file_time = os.stat(file_location).st_mtime
        if(file_time < current_time - day*RETENTION):
            if backup_files.startswith(HOSTNAME + "-" + SRCNAME) and backup_files.endswith('gz'):
                if DELETE == "y" or DELETE == "Y":
                    print("this process will delete old files")
                    logging.info('Delete: %s' % backup_files)
                    os.remove(file_location)
            else:
                logging.warn("There are no files to remove")
                sys.ext(0)
else:
    logging.info("No enough backups in %s" % DESTDIR)
