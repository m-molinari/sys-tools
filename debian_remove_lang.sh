#!/bin/bash

echo "Removing Firefox languages excluding en and it"
dpkg -l | grep firefox-esr-l10n | grep -v firefox-esr-l10n-it | grep -v firefox-esr-l10n-en-gb | awk '{print $2}' | xargs sudo apt-get remove --purge -y
echo

echo "Removing aspell dictionary excluding en and it"
dpkg -l | grep aspell | grep dictionary | grep -v aspell-it | grep -v aspell-en | awk '{print $2}' | xargs sudo apt-get remove --purge -y

echo "Removing hunspehunspell dictionary excluding en and it"
dpkg -l | grep hunspell | grep dictionary | grep -v hunspell-it | grep -v hunspell-en- | awk '{print $2}' | xargs sudo apt-get remove --purge -y
