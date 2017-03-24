#!/bin/sh

/usr/sbin/VBoxClient-all &

if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
       eval `dbus-launch --sh-syntax --exit-with-session`
fi

xrandr --dpi 192
xrdb -merge ~/.Xresources
setxkbmap fr mac &
xsetroot -cursor_name left_ptr
setxkbmap -option terminate:ctrl_alt_bksp
xset +fp /usr/share/fonts/TTF
xset +fp /usr/share/fonts/local
xset +fp /usr/share/fonts/artwiz-fonts

export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2

compton -b
unclutter -b

numlockx on &

sxhkd -c .config/sxhkd/sxhkdrc &

nitrogen --restore &
compton &

exec herbstluftwm

# exec twm
