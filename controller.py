__author__ = 'ceremcem'

from aktos_dcs import *
from gevent.subprocess import call


def run(command):
    retval = call(command)
    assert retval == 0
    return retval


class Control(Actor):
    def action(self):
        io_prompt = IoPrompt()
        io_prompt.send_cmd = self.eval_cmds
        io_prompt.start_io_prompt()

    def eval_cmds(self, cmd):
        if cmd == "load":
            self.send_CompileToLivescript()
            print "sent compile message..."
        elif cmd == "update-libs":
            print "Updating libs..."
            run("./update-libs.sh")
        else:
            print "cmd is not recognized..."



class CompileLivescript(Actor):

    def handle_CompileToLivescript(self, msg):
        try:
            print "Compiling livescript to javascript..."
            run("./make-bundle.sh".split())
            print "Sending 'LoadCode' message..."
            self.send_LoadCode()
        except:
            print "Error while compiling..."


ProxyActor()
CompileLivescript()
Control()
wait_all()
