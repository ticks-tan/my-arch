#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# set sxhkd 配置键盘快捷键
export SXHKD_SHELL='/usr/bin/sh'

# set dunst 配置通知
systemctl --user import-environment DISPLAY

# set clion
export _JAVA_AWT_WM_NONREPARENTING=1 
export AWT_TOOLKIT=MToolkit 
wmname LG3D

# chinese locale
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

# set qt theme
export QT_QPA_PLATFORMTHEME=qt5ct
# set qt font scale auto
export QT_AUTO_SCREEN_SCALE_FACTOR=1

# start dwm
exec dwm

# start bspwm
# exec bspwm
