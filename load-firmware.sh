#!/bin/bash

CURR_PWD=$(pwd)

PORT='/dev/ttyUSB0'
MAKEFILE_PORT=''
if [[ "$1" != "" ]]; then
    MAKEFILE_PORT="PORT=$1"
fi


wait_port_unplugged () {
    while [ -c $PORT ]; do
        sleep 0.1
    done
    sleep 1
}
wait_port_plugged () {
    until [ -c $PORT ]; do
        sleep 0.1
    done
    sleep 1
}
plug_unplug() {
    echo "<- Unplug the converter..."
    wait_port_unplugged
    echo "-> Plug the converter..."
    wait_port_plugged
    sleep 1
}


EMBEDDED="${HOME}/embedded"
cd $EMBEDDED

echo "Erasing flash first..."
until make erase-flash ${MAKEFILE_PORT}
do plug_unplug; done

plug_unplug

until make flash-espruino-esp8266-firmware ${MAKEFILE_PORT}
do plug_unplug; done

cd $CURR_PWD
