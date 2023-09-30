#!/bin/bash

/usr/bin/apt-get -s upgrade  | grep Debian-Security  | grep Inst | awk '{print $2 " " $3 " --> "  $4")"}'
