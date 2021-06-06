#!/usr/bin/env bash

# You can call this script like this:
# $ ./volumeControl.sh up
# $ ./volumeControl.sh down
# $ ./volumeControl.sh mute

# Script modified from these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_volume {
  pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,'
}

function is_mute {
  amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
  iconSound="/home/pablo-snz/.local/share/icons/kora-pgrey/panel/24/audio-on.svg"
  iconMuted="/home/pablo-snz/.local/share/icons/kora-pgrey/panel/24/audio-off.svg"
  if is_mute ; then
    # notify-send  -i $iconMuted -u normal "mute" --hint=string:x-dunst-stack-tag:test
    notify-send -u normal "                               婢   " --hint=string:x-dunst-stack-tag:test
  else
    volume=$(get_volume)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq --separator="─" 0 "$((volume / 5))" | sed 's/[0-9]//g')
    # Send the notification
    # notify-send  -i $iconSound -u normal "$volume     $bar" --hint=string:x-dunst-stack-tag:test
    #notify-send -u normal "          $bar    $volume" --hint=string:x-dunst-stack-tag:test
    #notify-send -u normal "  $volume       $bar   " --hint=string:x-dunst-stack-tag:test
    notify-send -u normal "  $volume   $bar   " --hint=string:x-dunst-stack-tag:test
  fi
}

case $1 in
  up)
    # set the volume on (if it was muted)
    pactl set-sink-mute $(pactl list short sinks | awk '{print $2}') off
    # up the volume (+ 5%)
    if [ $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,') -lt 150 ]; then 

    pactl set-sink-volume $(pactl list short sinks | awk '{print $2}') +5%
    fi
    send_notification
    ;;
  down)
    pactl set-sink-mute $(pactl list short sinks | awk '{print $2}') off
    pactl set-sink-volume $(pactl list short sinks | awk '{print $2}') -5%
    send_notification
    ;;
  mute)
    # toggle mute
    pactl set-sink-mute $(pactl list short sinks | awk '{print $2}') toggle
    send_notification
    ;;
esac

