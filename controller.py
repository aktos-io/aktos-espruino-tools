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

        else:
            print "cmd is not recognized..."



class CompileLivescript(Actor):

    def handle_CompileToLivescript(self, msg):
        """
        compress: {
		sequences: true,
		dead_code: true,
		conditionals: true,
		booleans: true,
		unused: true,
		if_return: true,
		join_vars: true,
		drop_console: true
		"""
        try:
            print "Compiling to livescript..."
            run("lsc -cb init.ls".split())
            run(("uglifyjs --mangle --compress" + " " +
                "sequences=true,dead_code=true,conditionals=true,booleans=true,unused=true" +
                "if_return=true,join_vars=true,drop_console=false" + " " +
                "-o init.min.js -- init.js").split())
            print "Sending 'LoadCode' message..."
            self.send_LoadCode()
        except:
            print "Error while compiling..."


ProxyActor()
CompileLivescript()
Control()
wait_all()
