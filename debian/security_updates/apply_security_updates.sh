#!/bin/bash

apt-get -s upgrade | grep Inst | grep Sec | awk '{print $2}' | xargs apt install -y

