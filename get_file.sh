#!/bin/bash
#this lets us change the synchronisation script location if ever necessary. allowing differentiation between versions.

test()
{
    wget --timeout=10 --spider www.github.com > /dev/null 2>&1
    if [ "$?" -eq 0 ]
    then
	      cd /home/turtlebot/scripts
        touch lock.file
        echo Network connection now initialised # do something

        rm sync.sh > /dev/null 2>&1
	      wget -q "https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/sync.sh"
	      chmod +x sync.sh
	      ./sync.sh > /home/turtlebot/scripts/sync.log 2>&1
        rm lock.file > /dev/null 2>&1
        exit
    else
        echo "No network connection available, skipping updates"
        sleep 5
    fi
}

cd /home/turtlebot/scripts
if [ -e lock.file ]
   echo "File locked, other process still running? otherwise remove manually"
   exit
test
