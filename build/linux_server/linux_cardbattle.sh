#!/bin/sh
echo -ne '\033c\033]0;Card_battle\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/linux_cardbattle.arm64" "$@"
