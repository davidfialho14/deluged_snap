#!/bin/bash

# Removes locale warnings
export LC_ALL=C

# The -d flag corresponds to the --no-daemonize option
# Here we let the snap system handle the daemonizing process
# This approach allows the output of deluged to be directed to systemd and,
# thereby, when running systemctl status
$SNAP/usr/bin/deluged -d
