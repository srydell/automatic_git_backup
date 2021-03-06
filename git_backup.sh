#!/usr/bin/env bash
#
# Author: Simon Rydell
# Date: 1 May 2018
# Input: Path to a directory under git source control
#
# Store backup of directory on remote server using git.
# Backups are stored in a private git repository

# Check that input is a directory
if [ -d "$1" ]; then
	dir_under_source_control="$1"
else
	printf "Input was not a directory. Given: %s" "$1"
	exit 1
fi

# Change to the right directory (exit if failed)
cd "$dir_under_source_control" || exit

if [[ "$(git status --porcelain)" ]]; then
	# Changes have been made

	# Log the time of the push
	# Format depends on locale
	# Example: tis 1 maj 2018 16:15:49
	time_of_backup=$(date +%c)

	# Add the changed files
	git add .

	# Set commit message
	git commit -m "Automatic backup: $time_of_backup"

	# Push the change to the remote server
	git push

	# Free up the variable names in reverse order
	unset time_of_backup
	unset dir_under_source_control
fi
