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

## Changing the Download Directory ##

Before starting to download all your torrents, we recommend you changing the default download directory to the directory you want to have deluge download the torrents to. You can configure this using any interface. Here we will use the console interface included in this snap. To set the download directory to '/path/to/downloads/directory' enter the following:

    menta-deluged.console "connect localhost USERNAME PASSWORD; config -s download_location /path/to/downloads/directory"
    
The USERNAME and PASSWORD should be replaced by the username and respetive password of a registered user (see  [Configuration and Management](#configuration-and-management)).

## Download Files to External Drive ##

To be able to point your downloads to an external drive you need to give the menta-deluged snap permission to access external drives. To do this enter the following:

    sudo snap connect menta-deluged:removable-media
    
Done! Now the menta-deluged snap is able to download your torrents to any external drive. To be more specific, the snap is able to access anything in the '/media/' directory.
