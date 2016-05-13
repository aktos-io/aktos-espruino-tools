# Status

Current status: **Works**, but needs improvements (BETA)

# Description

Tools for programming embedded devices (esp8266, stm32f4, etc...) with
[Espruino](http://espruino.com) platform.

Main objective of this toolset is transparently using [Livescript](http://livescript.net) while
programming embedded devices.

# Dependencies

1. Livescript (npm -i livescript -g)
2. UglifyJs (>=2.0)
3. aktos-dcs (https://github.com/aktos-io/aktos-dcs)
4. config-md (https://github.com/aktos-io/config-md)
5. aktos-embedded-tools (https://github.com/aktos-io/aktos-embedded-tools)

# Usage

1. Load Espruino firmware (`aea-espruino-load-firmware.sh`) (at least v1.85) to esp
2. run `aea-espruino-console` to connect the esp console
3. Place your application code in `./app/init.ls`
3. run `aea-espruino-ctl` to send commands (like "load")
    1. edit `init.ls`
    2. send `load` command in `aea-espruino-ctl` to upload code to the the device
