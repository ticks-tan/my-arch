#! /usr/bin/bash

# change the root dir
cd ~

ROOT_DIR=~/.config/autostart
LOG_DIR=${ROOT_DIR}/log

# check wm_check.sh is running
wmCheckPid=`ps aux | grep wm_check.sh | grep -v grep | awk '{print $2}'`
if [ "$wmCheckPid" ]; then
	kill -9 $wmCheckPid
	sleep 1
fi

# start playerctld 
playerctld daemon > ${LOG_DIR}/playerctld.log

wmCheckExec=`ps aux | grep wm_check.sh | grep -v grep`
if [ ! "$wmCheckExec" ]; then
	bash ${ROOT_DIR}/wm_check.sh > ${LOG_DIR}/wm_check.log &
fi

# start the conky
# conky -c /home/ticks/.config/conky/conky-vision/conky.conf -d > /dev/null
conky -c ~/.config/conky/NowPlaying/nowplaying -d > /dev/null

exit 0




