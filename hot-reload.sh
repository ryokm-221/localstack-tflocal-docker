#!/bin/bash -e
### sh hot-reload.sh <path/to/watch/file> <script> ###

if [ $# -ne 2 ]; then
  echo "usage: sh hot-reload.sh <path/to/watch/file> <script>"
  exit 1
fi

trap "watchman watch-del $(pwd)" EXIT

folder="$(pwd)/$1"
echo "watching folder $folder for changes"

while watchman-wait $folder; do
  bash -c "$2"
  watchman watch-del $folder
done
