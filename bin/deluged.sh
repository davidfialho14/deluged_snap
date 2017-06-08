#!/bin/bash

. $SNAP/default.conf

# Removes locale warnings
export LC_ALL=C

# We noticed deluged was trying to access the '.config/deluge/state' directory to
# write some data into it, but it was not able to do so because the directory
# was missing. Creating the directory solved the issue.
mkdir -p $SNAP_USER_DATA/.config/deluge/state
touch $SNAP_USER_DATA/.config/deluge/state/torrents.state
touch $SNAP_USER_DATA/.config/deluge/state/torrents.fastresume

# The auth file is used by deluge to store the users. The daemon accesses this
# file to check the username and password of each user trying to login
# Here auth is a link to a custom file storing the users credentials
# This approach provides flexibility to change the users file location
touch $USERS_FILE

# The -d flag corresponds to the --no-daemonize option
# Here we let the snap system handle the daemonizing process
# This approach allows the output of deluged to be directed to systemd and,
# thereby, when running systemctl status
$SNAP/bin/deluged -d
