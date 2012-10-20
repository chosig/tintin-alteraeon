#!/bin/bash
# Written by Kendell Clark and Storm Dragon
#Monday, September 10, 2012
#License GPL
#Purpose: Make it easy to set up multiple Alter Aeon characters with the tintin++ pack

#Do not allow this to be ran as root
if [ "$(whoami)" == "root" ] ; then
echo "This script should never be ran with root access."
exit 1
fi

create_character()
{
    mkdir -p $characterPath
    echo -e "#VARIABLE         {name}  \{$characterName\}\n#VARIABLE         {password}  \{$characterPassword\}" > $characterPath/name.tin
    #Link files.
    if [ -f "aa.tin" ] ; then
        ln aa.tin $characterPath/
     else
        echo "Error! Missing file aa.tin. Exiting."
        exit 1
    fi
    if [ -f "game_data.tin" ] ; then
        cp game_data.tin $characterPath/
     else
        echo "Error! Missing file game_data.tin. Exiting."
        exit 1
    fi
    if [ -f "cspam.tin" ] ; then
        ln cspam.tin $characterPath/
     else
        echo "Error! Missing file cspam.tin. Exiting."
        exit 1
    fi
    if [ -f "woadbot.tin" ] ; then
        ln woadbot.tin $characterPath/
     else
        echo "Error! Missing file woadbot.tin. Exiting."
        exit 1
    fi
    if [ -d "sounds" ] ; then
        ln -s $(pwd)/sounds/ $characterPath/
     else
        echo "Error! Missing sounds directory. Exiting."
        exit 1
    fi
}

#Create characters if info is passed on the command line.
if [ $# -gt 0 ] ; then
    if [ $(echo "$# % 2" | bc) -eq 0 ] ; then
        while [ $# -gt 0 ] ; do
            charactername="$1"
            characterPath="$HOME/$1"
            shift
            characterPassword="$2"
            shift
            create_character
        done
    else
        echo "Usage: ./$(basename "$(test -L "$0" && readlink "$0" || echo "$0")") character name character password."
        echo "You can have as many name and password sets as you want."
    exit 1
    fi
    exit 0
fi

#Get character names and passwords until user wants to exit.
while [ "$characterName" != "QUIT" ] ; do
    read -p "Enter your character's name and press enter or leave blank and press enter to exit:  " characterName
    if [ -n "$characterName" ] ; then
        read -p "Enter the password for $characterName, or leave blank if you would rather enter it manually at login:  " characterPassword
        #generate the directory for the new character's information.
        characterPath="$HOME/$characterName"
        create_character
    else
        characterName="QUIT"
    fi
done
exit 0
