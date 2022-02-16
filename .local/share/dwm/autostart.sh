#! /usr/bin/bash

# change the root dir
cd ~

ROOT_DIR=~/.local/share/dwm
LOG_DIR=${ROOT_DIR}/log

# 启动状态栏
# slstatusexec=`ps aux | grep slstatus | grep -v grep`
# if [ ! "$slstatusexec" ]; then
#	/usr/local/bin/slstatus > ${DWM_LOG_DIR}/slstatus.log 2<&1 &
# fi

# check wm_check.sh is running
wmCheckPid=`ps aux | grep wm_check.sh | grep -v grep | awk '{print $2}'`
if [ "$wmCheckPid" ]; then
	kill -9 $wmCheckPid
	sleep 1
fi

# check the conky
# conkyExec=`ps aux | grep conky | grep -v grep`
# if [ ! "$conkyExec" ]; then
#	conky --config=~/.config/conky/conky-vision/conky.conf --daemonize --pause=5 > ${LOG_DIR}/conky.log
# fi

# start playerctld 
playerctld daemon > ${LOG_DIR}/playerctld.log

wmCheckExec=`ps aux | grep wm_check.sh | grep -v grep`
if [ ! "$wmCheckExec" ]; then
	bash ${ROOT_DIR}/wm_check.sh > ${LOG_DIR}/wm_check.log &
fi

# start the conky
conky -c /home/ticks/.config/conky/conky-vision/conky.conf -d > /dev/null
conky -c /home/ticks/.config/conky/NowPlaying/nowplaying -d > /dev/null

exit 0




