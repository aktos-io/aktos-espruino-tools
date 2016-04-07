# Description

Device connects to aktos:1235 port over aea wifi connection and becomes transparent
between TCP connection and USART port.

# Dependencies

1. Livescript
2. UglifyJs
3. aktos-dcs

# Usage

1. Load Espruino firmware (`./load-firmware.sh`) (at least v1.85) to esp
2. run `python terminal_emulator.py` to connect the esp console
3. run `python controller.py` to send commands (like "load")
    1. edit `init.ls`
    2. send `load` command in `controller.py` to update the application
4. run `python tcp-server.py` and see connection
5. type something in "tcp-server" to send to esp

