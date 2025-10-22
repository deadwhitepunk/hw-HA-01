#!/bin/bash
load_average=$(uptime | awk '{print $8}' | sed 's/.\{1\}$//')
echo "$load_average"
PATH_TO_PRIORITY=/home/yc-user/priority

if [ ! -f "$PATH_TO_PRIORITY" ]; then
    echo "Error: File $PATH_TO_PRIORITY not found"
    exit 1
fi
if (( $(echo "$load_average > 1" | bc -l) )); then
    echo 1 > $PATH_TO_PRIORITY
else
    echo 0 > $PATH_TO_PRIORITY
fi