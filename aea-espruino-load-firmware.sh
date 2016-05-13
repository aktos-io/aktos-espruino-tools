#!/bin/bash

PORT='/dev/ttyUSB0'
if [[ "$1" != "" ]]; then
    PORT="$1"
fi

ESP_FIRMWARE_DIR="/home/ceremcem/embedded/Espruino/build/espruino_1v85.131_esp8266"

# See ${ESP_FIRMWARE_DIR}/README_flash.md
BAUD=115200
ESP_512K_CMD="esptool.py --port ${PORT} --baud ${BAUD} write_flash \
  --flash_freq 40m --flash_mode qio --flash_size 4m \
  0x0000 boot_v1.4(b1).bin 0x1000 espruino_esp8266_user1.bin 0x7E000 blank.bin"

ESP_4MB_CMD="esptool.py --port ${PORT} --baud ${BAUD} write_flash \
  --flash_freq 80m --flash_mode qio --flash_size 32m \
  0x0000 boot_v1.4(b1).bin 0x1000 espruino_esp8266_user1.bin 0x37E000 blank.bin"


ESP_ESPRUINO_CMD=${ESP_512K_CMD}
FLASH_SIZE=$(config-md -i config.md -k "hardware.flash size")
echo "FLASH size: $FLASH_SIZE"
if [[ "$FLASH_SIZE" == "4MB" ]]; then
    ESP_ESPRUINO_CMD=${ESP_4MB_CMD}
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
    sleep 3
}

wait-power-toggle() {
    echo "------------------------------"
    echo "Toggle power and press ENTER"
    echo "------------------------------"
    read -p ''
    sleep 1
}



echo "-------------------------------------------"
echo "ENTER the programming mode, toggle power..."
echo "-------------------------------------------"
read -p ''

CURR_DIR=$(pwd)
cd ${ESP_FIRMWARE_DIR}

#until esptool.py --port ${PORT} erase_flash
#do
#    wait-power-toggle
#done
#
#wait-power-toggle

until ${ESP_ESPRUINO_CMD}
do
    wait-power-toggle
done

cd ${CURR_DIR}

echo "----------------------------------------"
echo "EXIT PROGRAMMING MODE, Toggle Power...."
echo "----------------------------------------"
read -p ''



