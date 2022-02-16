#! /bin/bash

ROOT_DIR=~/.local/share/dwm
LOG_DIR=${ROOT_DIR}/log

# 计算运行时间(分钟)
secCount=0
# 壁纸刷新间隔
wallpaperChange=20

# 更换壁纸
bash ~/.fehbg > ${LOG_DIR}/feh.log &

while true
do
	# check wallpaper enging is running
	wallpaperExec=`ps aux | grep feh | grep -v grep`
	# check picom is running
	picomExec=`ps aux | grep picom | grep -v grep`
	# check fcitx5 is running
	fcitxExec=`ps aux | grep fcitx5 | grep -v grep`
	# check slstatus is running
	slstatusExec=`ps aux | grep slstatus | grep -v grep`
	# check xfce4-notifyd-manager is running
	notifydExec=`ps aux | grep xfce4-notifyd | grep -v grep`
	# check xfce4-power-manager is running
	powerManagerExec=`ps aux | grep xfce4-power-manager | grep -v grep`
	# check bubblemaild is running
	bubblemaildExec=`ps aux | grep bubblemaild | grep -v grep`

	# check polybar is running
	# polybarExec=`ps aux | grep polybar | grep -v grep`
	# check dunst is running
	# dunstExec=`ps aux | grep dunst | grep -v grep`

	if [ ! "$wallpaperExec" ]; then
		if [ $secCount == $wallpaperChange ]; then
			bash ~/.fehbg > ${LOG_DIR}/feh.log &
			let secCount=0
		fi
	fi

	if [ ! "$picomExec" ]; then
		picom --experimental-backends --config ~/.config/picom/picom.conf -b > ${LOG_DIR}/picom.log
	fi

	if [ ! "$slstatusExec" ]; then
		/usr/local/bin/slstatus > ${LOG_DIR}/slstatus.log &
	fi
	#if [ ! "$polybarExec" ]; then
		#bash ~/.config/polybar/launch.sh > ${LOG_DIR}/polybar.log &
	#fi

	#if [ ! "$dunstExec" ]; then
	#	dunst -conf ~/.config/dunst/dunstrc > ${LOG_DIR}/dunst.log &
	#fi

	if [ ! "$notifydExec" ]; then
		/usr/lib/xfce4/notifyd/xfce4-notifyd > ${LOG_DIR}/notifyd.log &
	fi

	if [ ! "$fcitxExec" ]; then
		fcitx5 > ${LOG_DIR}/fcitx5.log &
	fi

	if [ ! "$powerManagerExec" ]; then
		xfce4-power-manager --daemon > ${LOG_DIR}/power-manager.log
	fi

	if [ ! "$bubblemaildExec" ]; then
		bubblemaild > ${LOG_DIR}/bubblemaild.log &
	fi
	
	let secCount++

	sleep 1m

done
