#!/bin/bash
#
# Shell script to do simple SVN-like keyword expansion for
# release.
# Make sure you don't commit the files AFTER keyword expansion!
#
# Copyright (C) 2010 Robert Lange <sd2k9@sethdepot.org>
# Licensed under the GNU General Public License, version 2
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
#
#
# Supported Keywords are:
# Number of commits: $LastChangedRevision$


# *** Settings
# Files to change
FILES="osmfromtrack"

# Get commit count for the directory
REVCOUNT=$(git log --pretty=oneline |wc -l)

# *** Do $LastChangedRevision: 000$
echo "Perform LastChangedRevision expansion with value $REVCOUNT"
for fil in $FILES; do
    mv $fil ${fil}.bak
    sed -e "s/\\\$LastChangedRevision\\\$/\\\$LastChangedRevision: ${REVCOUNT}\\\$/g" ${fil}.bak > $fil
    echo "   $fil replaced"
done



# *** Reminder
echo
echo "Keyword expansion performed."
echo "Make sure you don't commit these files now! They are meant for export only."
echo
