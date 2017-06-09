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

## Troubleshooting ##

### I changed the download directory and now all downloads are stuck at 0.00% ###

This happened to me too :-p
I noticed that deluged is not able to download to a directory owned by a user that is not root. I'm not sure if this issue is related to deluged itself or due to the restrictions imposed on snaps. Regardless, I found a simple solution to the problem: making root the owner of the download directory xD
Assuming the download directory is '/path/to/downloads/directory' enter the following:

    sudo chown root /path/to/downloads/directory

At this point you should be able to download torrents normally.

However, this does not work very well, because root will be the owner and all the other users will not be able to acccess or modifiy the downloaded files. To fix this, I suggest keeping root as the owner and having a special group for this directory.

To create a new group 'example_g' enter:

    sudo groupadd example_g
    
Now change the group of the download directory to the new created group:

    sudo chgrp example_g /path/to/downloads/directory

After entering this command the owner and group of the download directory should be 'root' and 'example_g', respectively.
Changing the group of the download directory will not affect the group of the new files created by deluged (the downloaded files). At this oint if you download a torrent you'll see that all files are owned by root and their group is also root. Thus, we have the same problem. To fix this, we need to change the default group assinged to new files created on the download directory. This can be done with the following commands:

    sudo chmod g+s /path/to/downloads/directory
    sudo setfacl -d -m g::rw /path/to/downloads/directory

At this point deluged is downloading files correctly and the downloaded files are owned by root and the group is example_g.
Now, to give access read and write access to your user just ype the following:

    sudo usermod -a -G example_g YOU_USER
    
YOUR_USER should be replace with your username. You may need to logout and login back for the last change to take effect.
After all this steps your user should be able to manipulate the files downloaded by deluged.

