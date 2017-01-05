#!/bin/bash
#this lets us change the synchronisation script location if ever necessary. allowing differentiation between versions.

test()
{
    wget --timeout=10 --spider www.github.com > /dev/null 2>&1
    if [ "$?" -eq 0 ]
    then
        echo Network connection now initialised # do something
	      cd /home/turtlebot/scripts
        rm sync.sh > /dev/null 2>&1
	      wget -q "https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/sync.sh"
	      chmod +x sync.sh
	      ./sync.sh >> /home/turtlebot/scripts/sync.log
        exit
    else
        echo "No network connection available, skipping updates"
        sleep 5
    fi
}

test
