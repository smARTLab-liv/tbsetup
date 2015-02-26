#!/bin/bash
#disable blanking
setterm -blank 0
echo getting newest updates

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

# if [ -e battery.update ]
# then
#     echo battery already installed already set
# else
#     apt-get update
#     apt-get install acpi
#     echo TURTLEBOT_BATTERY=/sys/class/power_supply/BAT1 >> /etc/ros/setup.sh
# fi

# if [ -e acpi.update ]
# then
#     echo acpi already installed already set
# else
#     apt-get update
#     apt-get install acpi
#     touch acpi.update
# fi

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

# if [ -e /home/turtlebot/scripts/lcm.update ]
# then
#     echo lcm already installed
# else
#     wget http://lcm.googlecode.com/files/lcm-1.0.0.tar.gz
#     tar xzf lcm-1.0.0.tar.gz
#     cd lcm-1.0.0
#     ./configure
#     make
#     sudo make install
#     sudo ldconfig
#     sudo touch /home/turtlebot/scripts/lcm.update
# fi


# if [ -x /home/turtlebot/ros_catkin/src/turtlebot_swarmlab ]
# then
#     rm -rf /home/turtlebot/ros_catkin/src/turtlebot_swarmlab
# fi

# if [ -x /home/turtlebot/ros_catkin/src/executive_smach ]
# then
#     echo already checked out
# else
#   cd /home/turtlebot/ros_catkin/src
#   git clone https://github.com/ros/executive_smach.git
#   cd executive_smach
#   git checkout groovy-devel
# fi


# if [ -x /home/turtlebot/ros_catkin/src/swarming_turtles ]
# then
#     echo already checked out
# else
#     cd /home/turtlebot/ros_catkin/src
#     hg clone http://swarmlab.dyndns.org/swarmturtles/swarming_turtles
# fi


# cd /home/turtlebot/ros_catkin/src/swarming_turtles
# hg pull && hg up

# source /etc/ros/setup.bash
# source /opt/ros/groovy/setup.bash
# source /home/turtlebot/ros_catkin/devel/setup.bash

# export ROS_WORKSPACE=/home/turtlebot/ros_catkin
# export ROS_PACKAGE_PATH=/home/turtlebot/ros:$ROS_WORKSPACE:$ROS_PACKAGE_PATH

# if [ -e /home/turtlebot/scripts/battery.update ]
# then
#     echo battery already installed
# else
#     cd /home/turtlebot/ros_catkin/src/turtlebot/linux_hardware/scripts
#     wget -q http://swarmlab.dyndns.org/tbsetup/tbsetup/raw-file/tip/linux_battery.patch
#     patch -p3 < linux_battery.patch
#     cd ..
#     rosdep update
#     export ROS_PACKAGE_PATH=/home/turtlebot/ros_catkin/src/turtlebot:$ROS_PACKAGE_PATH
#     rosmake linux_hardware
#     sudo touch /home/turtlebot/scripts/battery.update
# fi

# cd /home/turtlebot/ros_catkin

# echo making catkin
# catkin_make

# eof

