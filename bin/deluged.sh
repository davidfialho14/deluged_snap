#!/bin/bash

. $SNAP/default.conf

# Removes locale warnings
export LC_ALL=C

# The deluge daemon creates directories containing configurations and the
# downloads inside teh user's home directory
# Here the daemon runs with the root user and therefore HOME will point to the
# root snap home directory (directory pointed by SNAP_USER_DATA for root user)
# At the time, after removing a snap, the data place in the root snap home
# directory is not deleted and the documentation suggests using the SNAP_DATA
# directory to place data from long running services as the deluge daemon
# Because of this, we set the root home directory to the SNAP_DATA directory
export HOME=$SNAP_DATA

# We noticed deluged was trying to access the '.config/deluge/state' directory to
# write some data into it, but it was not able to do so because the directory
# was missing. Creating the directory solved the issue.
mkdir -p $SNAP_DATA/.config/deluge/state
touch $SNAP_DATA/.config/deluge/state/torrents.state
touch $SNAP_DATA/.config/deluge/state/torrents.fastresume

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
