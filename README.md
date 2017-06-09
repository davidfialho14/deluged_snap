# Deluge Daemon Snap

Unofficial snap for the deluge daemon

This snap package was built to meet a very specific set of requirements. The
configurations included here may not apply for more generic use cases.

## Installation Instructions ##

Type the following command to install the deluged snap:

    sudo snap install menta-deluged --beta
    
That's it! The deluge daemon is now installed and should already running.
Check if deluged (deluge daemon) is tunning with the following command:

    sudo systemctl status snap.menta-deluged.deluged

## Configuration and Management ##

To configure and manage the deluge daemon you can use the deluge console interface included in this snap. But, previously you need to register a new user to be able to use the console interface. To do this you can use the 'users' command. Here it is shown the usage instructions presented when you use the help option (-h | --help):

    Usage: users list
           users COMMAND <username>

    Commands:
        list:       Lists all registered users
        create:     Creates a new user
        delete:     Deletes a user
        
Note this command requires root permissions. 
The 'users' command provides three possible commands: list, create, and delete. 

The list command takes no arguments and shows a list with all the currently registered users. 
The create and delete commands take a single argument that should be the username of the user to be created or deleted.

To create a user with the username 'example' enter the following:

    sudo menta-deluged.users create example

Then, you'll be prompted to input a password for that user (note the password is requested twice). Afterwards, the user example is created and can now be used to access the daemon either using the console interface included in this snap or any other deluge interface that you prefer (see http://dev.deluge-torrent.org/wiki/UserGuide/ThinClient#ClientSetup).

To delete the user 'example' enter:

    sudo menta-deluged.users delete example

This interface can be accessed using the 'console' command. For instance, to 

After having a registered user you can use the 'console' command to manage and configure any aspect of deluged. To open up this interface enter:

    menta-deluged.console

See https://whatbox.ca/wiki/deluge_console_documentation to learn more about how to use this interface.

