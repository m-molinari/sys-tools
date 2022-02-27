#!/bin/bash

/usr/bin/dpkg -l | grep firefox-esr-l10n | grep -v firefox-esr-l10n-it | grep -v firefox-esr-l10n-en-gb | awk '{print $2}' | xargs sudo apt-get remove -y
