#!/bin/bash
#disable blanking
setterm -blank 0
echo getting newest updates

cd /home/turtlebot/scripts/

rm get_file.sh* > /dev/null 2>&1
wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/get_file.sh
chmod +x get_file.sh

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

if [ -e hostnames1.update ]
then
    echo Hostname file already updated
else
    rm hosts*  > /dev/null 2>&1
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/hosts
    hostname=$(cat /etc/hostname)
    cat hosts | sed s/"HOSTNAME"/"$hostname"/ > /tmp/newhosts
    mv /tmp/newhosts /etc/hosts
    touch hostnames1.update
fi

if [ -e minimal_launch.update ]
then
    echo Minimal launch updated
else
    rm minimal.launch*  > /dev/null 2>&1
    wget -q https://raw.githubusercontent.com/smARTLab-liv/smartlab_turtlebot_launchers/master/launch/minimal.launch
    mv minimal.launch /etc/ros/indigo/turtlebot_bringup.d/
    touch minimal_launch.update
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


if [ -e master_sync.update ]
then
    echo master_sync.update already set
else
    apt-get update
    apt-get install -y ros-indigo-master-sync-fkie
    touch master_sync.update
fi

if [ -e libsvm.update ]
then
    echo libsvm.update already set
else
    apt-get update
    apt-get install -y libsvm-dev
    touch libsvm.update
fi

if [ -e people.update ]
then
    echo people.update already set
else
    apt-get update
    apt-get install -y ros-indigo-people
    touch people.update
fi

if [ -e env.update ]
then
    echo env already installed already set
else
    echo export TURTLEBOT_3D_SENSOR=kinect >> /etc/environment
    echo export TURTLEBOT_BATTERY=/sys/class/power_supply/BAT1 >> /etc/environment
    touch env.update
    do_reboot=1
fi

if [ -e dist_upgrade.update ]
then
    echo env already installed already set
else
    grub-install /dev/sda
    apt-get update
    apt-get install tmux distcc -y

    unset UCF_FORCE_CONFFOLD
    export UCF_FORCE_CONFFNEW=YES
    ucf --purge /boot/grub/menu.lst

    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get -o Dpkg::Options::="--force-confdef" --force-yes -fuy dist-upgrade
    touch dist_upgrade.update
    do_reboot=1
fi


if [ "$do_reboot" -eq 1 ]
then
    reboot
fi

## time update
/usr/sbin/ntpdate ntp.ubuntu.com


### OLD

# if [ -e locale.update ]
# then
#     echo locale already installed already set
# else
#     echo LC_ALL="en_GB.utf8" >> /etc/environment
#     touch locale.update
# fi



##all the rest will be done as user turtlebot
sudo -H -u turtlebot /bin/bash - << eof

if [ -x /home/turtlebot/smartlab_dotfiles ]
then
    echo already checked out smartlab_dotfiles
    cd /home/turtlebot/smartlab_dotfiles
    git pull
else
    cd /home/turtlebot/
    git clone git@github.com:smARTLab-liv/smartlab_dotfiles.git
fi

if [ -x /home/turtlebot/ros/src/spencer_people_tracking ]
then
    echo already checked out spencer tracking code
else
    cd /home/turtlebot/ros/src
    git clone https://github.com/spencer-project/spencer_people_tracking.git
fi

if [ -x /home/turtlebot/ros/src/collvoid ]
then
    echo already checked out
    cd /home/turtlebot/ros/src/collvoid
    git pull
    git checkout highly_experimental
else
    cd /home/turtlebot/ros/src
    git clone https://github.com/daenny/collvoid.git -b highly_experimental
fi

if [ -x /home/turtlebot/ros/src/swarming_turtles ]
then
    cd /home/turtlebot/ros/src/swarming_turtles
    git pull
fi

eof

# source /opt/ros/indigo/setup.bash
# source /home/turtlebot/ros/devel/setup.bash

# export ROS_WORKSPACE=/home/turtlebot/ros
# export ROS_PACKAGE_PATH=$ROS_WORKSPACE:$ROS_PACKAGE_PATH

# cd /home/turtlebot/ros

# echo making catkin
# catkin_make


