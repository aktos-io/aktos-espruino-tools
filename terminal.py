__author__ = 'ceremcem'

from aktos_dcs import *


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
        with open("init.min.js", 'r') as f:
            src = ''.join(f.readlines()).replace("\n", "")
            print repr(src)
            self.send_cmd("reset()")
            sleep(2)
            self.send_cmd(src)
            self.send_cmd("save()")

ProxyActor()
TerminalEmulator(port="/dev/ttyUSB0", baud=115200)
wait_all()
