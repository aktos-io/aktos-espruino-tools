#!/usr/bin/env python
# coding: utf-8

from aktos_dcs import *
import os

class TerminalEmulator(SerialPortReader):
    def prepare(self):
        print "started terminal emulator..."
        print "-----------------------------"
        print self.ser
        self.line_endings = "\n"

    def action(self):
        self.start_io_prompt()

    def on_disconnect(self):
        print ""
        print "[[ Device Physically Disconnected... ]]"
        print ""

    def on_connecting(self):
        print ""
        while True:
            print "[[ Waiting for Device to be physically connected... ]]"
            sleep(30)

    def on_connect(self):
        print ""
        print "[[ Device Physically Connected... ]]"
        print ""


    def handle_LoadCode(self, msg):
        app_folder = "app"
        self.send_cmd("reset()")
        sleep(4)
        for file in os.listdir(app_folder):
            if file.endswith(".min.js"):
                with open(app_folder + "/" + file, 'r') as f:
                    for line in f.readlines():
                        #print "INFO: SENDING CODE LINE: ", repr(line)
                        self.send_cmd(line)
                        sleep(0.3)

        sleep(1)
        self.send_cmd("save()\n")

ProxyActor()
config = AktosConfig("./app/config.md")
port = config.get("console.port", "/dev/ttyUSB0")
baud = config.get("console.baud", 115200)
print "Configuration: %s @%d baud" % (port, baud)
TerminalEmulator(port=port, baud=baud)
wait_all()
