#!/bin/bash

LED="/sys/class/leds/platform::micmute/brightness"
SUDO="/usr/bin/sudo"
TEE="/usr/bin/tee"
PACTL="/usr/bin/pactl"

MUTE=$($PACTL get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
if [ "$MUTE" = "yes" ]; then
  echo 1 | $SUDO $TEE "$LED"
else
  echo 0 | $SUDO $TEE "$LED"
fi

$PACTL subscribe | while read -r event; do
  if echo "$event" | grep -q "source"; then
    MUTE=$($PACTL get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')
    if [ "$MUTE" = "yes" ]; then
      echo 1 | $SUDO $TEE "$LED"
    else
      echo 0 | $SUDO $TEE "$LED"
    fi
  fi
done
