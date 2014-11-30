#!/bin/bash
#
# Filter script to do simple SVN-like keyword expansion for
# release. The keywords are expanded in the working copy.
# Can be used with git filters - see file .gitattributes
# Text to change is taken from stdin
#
# Copyright (C) 2014 Robert Lange <sd2k9@sethdepot.org>
# Licensed under the GNU General Public License, version 3
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see {http://www.gnu.org/licenses/}.
#
#
# Supported Keywords are:
# Number of commits: $LastChangedRevision$
# Last commit date: $LastChangedDate$


# *** Settings
# Version Text to prepend
VERSION_PREPEND="0."
# Mode to do
MODE="$1"
# Files to consider as master - currently not used
FILE="$2"


case "$MODE" in
"expand")
  # *** Filter to run during checkout: Do keyword expansion

  # Get commit count for the repository
  REVCOUNT=$(git log --pretty=oneline -- |wc -l)
  VERSION="${VERSION_PREPEND}${REVCOUNT}"
  # Get date for the repository
  DATE=$(git log --date=short --pretty=format:"%ad" -1 -- )

  # Status infos - not allowed for filter
  # echo "Version: ${VERSION}"
  # echo "Date: ${DATE}"
  # echo "Files to change: ${FILESTOCHANGE}"

  # *** Perform changes
  # Change keyword files
  cat  | \
     sed -e "s/\\\$LastChangedRevision.*\\\$/\\\$LastChangedRevision: ${VERSION}\\\$/g" | \
     sed -e "s/\\\$LastChangedDate.*\\\$/\\\$LastChangedDate: ${DATE}\\\$/g"


  # Done
  exit 0
  ;;

"clean")
  # Filter to run during staging: Make file clean again

  cat | \
     sed -e "s/\\\$LastChangedRevision.*\\\$/\\\$LastChangedRevision\\\$/g" | \
     sed -e "s/\\\$LastChangedDate.*\\\$/\\\$LastChangedDate\\\$/g"

  # Done
  exit 0
  ;;


*)
  # Unknown command: Do nothing
  cat
  exit 1
  ;;

esac
