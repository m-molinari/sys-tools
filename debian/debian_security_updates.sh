#!/bin/bash
#
# This is a script that list security updates available on Debian OS (possible sending an email notification)
#

# Update apt cache
/usr/bin/apt-get update -qq

declare -i SEC_UPDATES=0
SERVER=`hostname`
SEC_UPDATES=$(/usr/bin/apt-get -s upgrade | grep Debian-Security | grep -c Inst)
SEC_UPDATES_LIST=$(/usr/bin/apt-get -s upgrade | grep Debian-Security | grep Inst | awk '{print $2 " " $3 " --> "  $4")"}')

# Usage
usage() {
        echo "Usage: $0 [OPTION ...]"
        echo
        echo "Examples:"
        echo "$0 show if there are security updates"
        echo "$0 -m -f sender@example.com (optional) -t rcpt@example.com (must)"
        echo
        echo "Arguments:"
        echo "-m if present mail will be send"
        echo "-f from email (optional)"
        echo "-t rcpt email (must)"
        echo
        exit 1
}

        while getopts ":f:t:m" opt; do
            case "${opt}" in
                f)
                    MY_FROM=${OPTARG}
                    ;;
                t)
                    MY_TO=${OPTARG}
                    ;;
                m)
                    MAIL=1
                    ;;
                *)
                    usage
                    ;;
            esac
        done

if [ "$MAIL" == "1"  ]; then

        # Must arguments
        if [ -z $MY_TO ]; then
                usage
                exit 1
        fi

        if [ $SEC_UPDATES -gt 0  ] ; then
                echo -e "There are  $SEC_UPDATES security updates on $SERVER :\n\n$SEC_UPDATES_LIST" \
                | mail -s "Security udates reminder $SEC_UPDATES" $MY_TO -a "From: $MY_FROM"
                exit 2
        else
                echo -e "No security updates available on $SERVER\n" \
                |  mail -s "Security udates reminder $SEC_UPDATES" $MY_TO -a "From: $MY_FROM"

                if [ $? -gt 0 ]; then
                    echo "Failed, no mail send"
                    exit 2
                else
                    echo "Email successfully sended to $MY_TO"
                    exit 0
                fi
        fi
else
        if [ $SEC_UPDATES -gt 0  ] ; then
                echo -e "There are  $SEC_UPDATES security updates on $SERVER :\n\n$SEC_UPDATES_LIST"
                exit 2
        else
                echo -e "No security updates available on $SERVER\n"
                exit 0
        fi
fi
