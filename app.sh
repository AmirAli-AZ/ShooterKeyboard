#!/usr/bin/env bash

if ! command -v evtest > /dev/null 2>&1; then
  echo "\"evtest\" is not installed on your machine"
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

bash welcome.sh

trap "tput sgr0; tput cnorm; stty echo < /dev/tty" EXIT INT TERM

read -r -p "Enter your device input(check \"sudo evtest\" to see list of devices): " DEVICE
USER_NAME=$(logname)
USER_UID=$(id -u "$USER_NAME")

tput civis
stty -echo

playSound() {
  sudo -u "$USER_NAME" env \
                      XDG_RUNTIME_DIR="/run/user/$USER_UID" \
                      pw-play "$1" &
}

echo "Listening for keypresses on $DEVICE..."

while read -r line; do
    if echo "$line" | grep -q "Event: time.*type 1 (EV_KEY).*value 1"; then
        KEY=$(echo "$line" | grep -oP "code \d+ \(\K[^)]+")

        case "$KEY" in
          KEY_ENTER)
            playSound soundfiles/ai-l96a1.mp3
          ;;
          KEY_SPACE)
            playSound soundfiles/gun-reload-sound.mp3
          ;;
          KEY_ESC)
            exit 0
          ;;
          KEY_[0-9] | KEY_KP[0-9])
            playSound soundfiles/barrett-m82-a1.mp3
          ;;
          *)
            playSound soundfiles/ak-47.mp3
          ;;
        esac
    fi
done < <(evtest "$DEVICE")
