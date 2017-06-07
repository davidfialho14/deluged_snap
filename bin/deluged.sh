#!/bin/bash

# Removes locale warnings
export LC_ALL=C

# We noticed deluged was trying to access the '.config/deluge/state' directory to
# write some data into it, but it was not able to do so because the directory
# was missing. Creating the directory solved the issue.
mkdir -p $SNAP_USER_DATA/.config/deluge/state

# Create the auth file which will contain the registered users
touch $SNAP_USER_DATA/.config/deluge/auth

# The -d flag corresponds to the --no-daemonize option
# Here we let the snap system handle the daemonizing process
# This approach allows the output of deluged to be directed to systemd and,
# thereby, when running systemctl status
$SNAP/usr/bin/deluged -d
