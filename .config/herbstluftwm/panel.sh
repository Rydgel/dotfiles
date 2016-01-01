#!/bin/bash

# Just a dirty script for lemonbar,
# you need to use 'siji' font for icons.

# (echo "१ २ ३ ४ ५ ६ ७ ८ ९"; sleep 3) | lemonbar -g 120x16+0+20 -f "Lohit Devanagari-12"

# main monitor
monitor=${1:-0}

# padding
herbstclient pad $monitor 16

# settings
#RES="x16+1280x"
RES="x16"
FONT="*-siji-medium-r-*-*-10-*-*-*-*-*-*-*"
FONT2="-*-cure.se-medium-r-*-*-11-*-*-*-*-*-*-*"
FONT3="IPAGothic-8"
BG="#1D2426"
FG="#8FA388"
BLK="#39474A"
RED="#986345"
YLW="#788249"
BLU="#3E5951"
GRA="#977D5E"
VLT="#B9924A"

# icons
st="%{F$YLW}  %{F-}"
sm="%{F$RED}  %{F-}"
sv="%{F$BLU}  %{F-}"
sd="%{F$VLT}  %{F-}"

# functions
set -f
	
function uniq_linebuffered() {
    awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

# events
{   
    # now playing
    mpc idleloop player | cat &
    mpc_pid=$!

    # volume
    while true ; do
        echo "vol $(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	sleep 1 || break
    done > >(uniq_linebuffered) &
    vol_pid=$!
    
    # date
    while true ; do
        date +'date_min %b %d %A '%{F$RED}%{F-}' %H:%M'
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!

    # herbstluftwm
    herbstclient --idle

    # exiting; kill stray event-emitting processes
    kill $mpc_pid $vol_pid $date_pid    
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    unset TAGS[${#TAGS[@]}]
    time=""
    song="nothing to see here"
    windowtitle="what have you done?"
    visible=true

        while true ; do
        echo -n "%{l}"
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#') # current tag
                    echo -n "%{U$RED}%{+u}"
                    ;;
                '+') # active on other monitor
                    echo -n "%{U$YLW}%{+u}"
                    ;;
                ':')
                    echo -n "%{-u}"
                    ;;
                '!') # urgent tag
                    echo -n "%{U$YLW}"
                    ;;
                *)
                    echo -n "%{-u}"
                    ;;
            esac
            echo -n " ${i:1} "
        done
	
	# center window title
	echo -n "%{c}$st%{F$GRA}${windowtitle//^/^^} %{F-}"
	
        # align right
        echo -n "%{r}"
        echo -n "$sm"
        echo -n "$song" %{F$YLW}"$song2"%{F-}
        echo -n "$sv"
        echo -n "$volume"
        echo -n "$sd"
        echo -n "$date "
        echo ""
	
        # wait for next event
        read line || break
        cmd=( $line ) 
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                TAGS=( $(herbstclient tag_status $monitor) )
                unset TAGS[${#TAGS[@]}]
                ;;
            mpd_player|player)
                song="$(mpc -f %artist% current)"
		song2="$(mpc -f %title% current)"
                ;;
            vol)
                volume="${cmd[@]:1}"
                ;;
            date_min)
                date="${cmd[@]:1}"
                ;;
	    focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            quit_panel)
                exit
                ;;
            reload)
                exit
                ;;
        esac
    done
} 2> /dev/null | lemonbar -g ${RES} -u 3 -B ${BG} -F ${FG} -f ${FONT} -f ${FONT2} -f ${FONT3} & $1
