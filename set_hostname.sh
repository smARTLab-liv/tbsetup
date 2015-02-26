#!/bin/bash          

#WARNING - THIS IS UNTESTED AND MIGHT REALLY HOSE YOUR SYSTEM.
#You got it for free off the internet. You have been warned.

macAddress="$(ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')"

#macList=("b8:88:e3:a3:dd:2d" "b8:88:e3:a5:16:c9" "b8:88:e3:a5:16:b6" "b8:88:e3:a5:13:01" "b8:88:e3:a5:11:af" "b8:88:e3:a5:12:f3" "b8:88:e3:a5:11:c9" "b8:88:e3:a5:12:d6" "b8:88:e3:a5:16:a7" "b8:88:e3:a3:db:b9" "b8:88:e3:a5:16:ae" "b8:88:e3:a5:16:e7" "b8:88:e3:a5:16:db" "b8:88:e3:a5:12:f0" "b8:88:e3:a5:13:31")

macList=($(cat macadr-eth1.txt))


oldname=$(cat /etc/hostname)

counter=0
newname="not found"

for i in "${macList[@]}"
do
    counter=$(($counter+1))
    if [ "$i" == "$macAddress" ] ; then
        echo "$counter"
	printf -v suffix "%02d" $counter
	newname="tb$suffix"
    fi
done

echo "$newname"
if [ "$newname" == "not found" ] ; then
    echo "MAC address not found in list. Exiting"
    exit
fi

# You'll need to test that the new name exists here, and exit gracefully if it does not.

hostname "$newname"
echo "Hostname changed from $oldname to $newname"

cat /etc/hostname | sed s/"$oldname"/"$newname"/ > /tmp/newhostname
mv /tmp/newhostname /etc/hostname
echo "The /etc/hostname file has been changed"


cat /etc/hosts | sed s/"$oldname"/"$newname"/ > /tmp/newhosts
mv /tmp/newhosts /etc/hosts
echo "The /etc/hosts file has been changed"

echo "Don't forget to logout and log back in before your X server crashes..."

touch hostname.update