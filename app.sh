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

read -r -p "Enter your device input(check \"sudo evtest\" to see list of devices): " DEVICE
USER_NAME=$(logname)
USER_UID=$(id -u "$USER_NAME")

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
            playSound soundfiles/gun-echo-sound.mp3
          ;;
          KEY_SPACE)
            playSound soundfiles/gun-reload-sound.mp3
          ;;
          KEY_ESC)
            echo -e "\033[0m"
            exit 0
          ;;
          *)
            playSound soundfiles/gun-sound.mp3
          ;;
        esac
    fi
done < <(evtest "$DEVICE")
