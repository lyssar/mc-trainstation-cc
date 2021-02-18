#!/bin/bash

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

CRAFT_OS=$(read_var CRAFT_OS .env)
MOUNT=$(read_var MOUNT .env)

if [[ "$OSTYPE" == "win32"* ]] || [[ "$OSTYPE" == "msys"* ]]
then
    start "" "$CRAFT_OS" --mount-rw "lystrain"="$MOUNT"
else
    craftos --mount-rw "lystrain"="$MOUNT"
fi
