#!/bin/bash
groupmod -g $gid voc
usermod -u $uid -g $gid voc

# check if homedir is mounted
if grep -q '/home/voc' /proc/mounts; then
	# homedir is mounted into the docker...
	true
else
	# fixup for changed uid and gid
	chown -R voc:voc /home/voc
fi

# run voctocore as voc user
if [ -x /bin/gosu ]; then
	gosu voc /opt/voctomix/voctocore/voctocore.py -v
else
	echo "no gosu found..."
	exec su -l -c "/opt/voctomix/voctogui/voctogui.py -v" voc
fi
