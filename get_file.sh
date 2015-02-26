#!/bin/bash
#this lets us change the synchronisation script location if ever necessary. allowing differentiation between versions.

test()
{
    wget --timeout=10 --spider swarmlab.dyndns.org > /dev/null 2>&1
    if [ "$?" -eq 0 ]
    then
        echo Network connection now initialised # do something
        rm sync.sh > /dev/null 2>&1
	wget -q "http://swarmlab.dyndns.org/tbsetup/tbsetup/raw-file/tip/sync.sh"
	chmod +x sync.sh
	./sync.sh
        exit
    else
        echo "No network connection available, skipping updates"
           sleep 5
    fi
}

test