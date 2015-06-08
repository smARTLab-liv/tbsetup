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
    rm set_hostname.sh*
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/set_hostname.sh
    wget -q https://raw.githubusercontent.com/smARTLab-liv/tbsetup/master/macadr-eth1.txt
    chmod +x set_hostname.sh
    ./set_hostname.sh
    do_reboot=1
fi

if [ "$do_reboot" -eq 1 ]
then
    reboot
fi

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

eof

# if [ -x /home/turtlebot/ros_catkin/src/swarming_turtles ]
# then
#     echo already checked out
# else
#     cd /home/turtlebot/ros_catkin/src
#     hg clone http://swarmlab.dyndns.org/swarmturtles/swarming_turtles
# fi


# cd /home/turtlebot/ros_catkin/src/swarming_turtles
# source /etc/ros/setup.bash
# source /opt/ros/groovy/setup.bash
# source /home/turtlebot/ros_catkin/devel/setup.bash

# export ROS_WORKSPACE=/home/turtlebot/ros_catkin
# export ROS_PACKAGE_PATH=/home/turtlebot/ros:$ROS_WORKSPACE:$ROS_PACKAGE_PATH

# cd /home/turtlebot/ros

# echo making catkin
# catkin_make

# eof

