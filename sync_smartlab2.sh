#!/bin/bash
#disable blanking
setterm -blank 0
echo getting newest updates

cd /home/turtlebot/scripts/

rm get_file_smartlab2.sh* > /dev/null 2>&1
wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/get_file_smartlab2.sh
chmod +x get_file_smartlab2.sh

echo Checking for System Updates

do_reboot=0

#disable wlan save mode
/sbin/iwconfig wlan0 power off

if [ -e hostname.update ]
then
    echo Hostname already set
else
    rm set_hostname.sh*  > /dev/null 2>&1
    rm macadr-eth1.txt*  > /dev/null 2>&1
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/set_hostname.sh
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/macadr-eth1.txt
    chmod +x set_hostname.sh
    ./set_hostname.sh
    do_reboot=1
fi

if [ -e hostnames.update ]
then
    echo Hostname file already updated
else
    rm hosts*  > /dev/null 2>&1
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/hosts
    hostname=$(cat /etc/hostname)
    cat hosts | sed s/"HOSTNAME"/"$hostname"/ > /tmp/newhosts
    mv /tmp/newhosts /etc/hosts
    touch hostnames.update
fi

if [ -e bash_rc.update ]
then
    echo bash-rc updated
else
    rm ../.bashrc*  > /dev/null 2>&1
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/.bashrc
    mv .bashrc ../
    touch bash-rc.update
fi

if [ "$do_reboot" -eq 1 ]
then
    reboot
fi

## time update
/usr/sbin/ntpdate ntp.ubuntu.com


##all the rest will be done as user turtlebot
sudo -H -u turtlebot /bin/bash - << eof


eof


