#!/bin/bash

CURR_PWD=$(pwd)

PORT='/dev/ttyUSB0'
if [[ "$1" != "" ]]; then
    PORT="$1"
fi

MAKEFILE_FLASH_SIZE="4m"
FLASH_SIZE=$(config-md -i config.md -k "hardware.flash size")
echo "FLASH size: $FLASH_SIZE"
if [[ "$FLASH_SIZE" == "4MB" ]]; then
    MAKEFILE_FLASH_SIZE="32m"
fi

ESPTOOL_OPTS="PORT=$PORT FLASH_SIZE=$MAKEFILE_FLASH_SIZE"


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
    sleep 3
}

wait-power-toggle() {
    echo "------------------------------"
    echo "Toggle power and press ENTER"
    echo "------------------------------"
    read -p ''
    sleep 1
}


EMBEDDED="${HOME}/embedded"
cd $EMBEDDED

echo "-------------------------------------------"
echo "ENTER the programming mode, toggle power..."
echo "-------------------------------------------"
read -p ''


until make erase-flash ${ESPTOOL_OPTS}
do
    wait-power-toggle
done

wait-power-toggle

until make flash-espruino-esp8266-firmware ${ESPTOOL_OPTS}
do
    wait-power-toggle
done

echo "----------------------------------------"
echo "EXIT PROGRAMMING MODE, Toggle Power...."
echo "----------------------------------------"
read -p ''

cd $CURR_PWD
