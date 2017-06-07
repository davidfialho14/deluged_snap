#!/bin/bash
set -e

. $SNAP/default.conf

##
# Script to manage users
# Users are registered in the USERS_FILE defined in the default.conf file
#
# This script is associated with the 'users' command
# To understand how users are managed by deluged see http://dev.deluge-torrent.org/wiki/UserGuide/Authentication
##

function usage {
  echo "Usage: users list"
  echo "       users COMMAND <username>"
  echo
  echo "Commands:"
  echo "    list:       Lists all registered users"
  echo "    create:     Creates a new user"
  echo "    delete:     Deletes a user"
  echo
}

function users {
  cut -d: -f1 $USERS_FILE
}

function user_exists {
  existing_user=$1

  for user in $(users);
  do
    if [ "$user" = "$existing_user" ]; then
      return 0
    fi
  done

  return 1

}

function read_password {
  password=

  while true; do
    read -s -p "Password: " password
    echo
    read -s -p "Password (again): " password_confirm
    echo

    if [ "$password" = "$password_confirm" ]; then
      break
    fi

    echo "Error: passwords do not match"
    echo "Please try again"
  done
}

function create {
  local username=$1

  if user_exists $username; then
    echo "User '$username' already exists"
    exit 1
  fi

  echo "Lets create a new user with name '$username'"
  echo "Please provide a password for the new user"

  # returns the user inputted password in the $password variable
  read_password;

  # Deluge defines multiple authentication levels. Here we use level 10 which
  # indicates an Admin user
  touch $USERS_FILE
  echo "$username:$password:10" >> $USERS_FILE

  echo "Successfully created new user '$username'"

}

function delete {
  local user_to_delete=$1

  local line_number=1
  for user in $(users);
  do

    if [ "$user" = "$user_to_delete" ]; then
      sed -i "${line_number}d" $USERS_FILE
      echo "Successfully deleted user '$user_to_delete'"
      exit 0
    fi

    line_number=$((line_number+1))

  done

  echo "There is no user with name '$user_to_delete'"
}

function list {

  local all_users=$(users)

  if [ -z $all_users ]; then
    echo
    echo "There are no users registered yet"
    echo "Use the following command to create a new user: "
    echo "    menta-deluged.users create <username>"
    echo
    exit 0
  fi

  echo "USERS"
  for user in $all_users;
  do
    echo "- $user"
  done

}

function main {

  if [ $(id -u) -ne 0 ]; then
    echo "The '$1' command requires root permissions (try using sudo)"
    exit 1
  fi

  case "$1" in
    create|delete)

          if [ "$#" -ne "2" ]; then
            usage;
            exit 1
          fi
          ${1} ${2}

          ;;

    list)
          ${1} ;;

    -h|--help)
          usage
          exit 1
          ;;

    -*)   echo "Argument error. Use the -h option." ;;
    *)    echo "Command error. Use the -h option." ;;
  esac

}

main "$@";
