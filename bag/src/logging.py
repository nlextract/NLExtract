# To change this template, choose Tools | Templates
# and open the template in the editor.

__author__="miblon"
__date__ ="$Jun 13, 2011 11:34:17 AM$"

from time import *
import sys

# An extremely simple Singleton logger
class Log:
    # Singleton: sole static instance of Log to have a single Log object
    log = None

    # timer to keep start of time interval
    # TODO: make this stack to support nested timings
    t1 = None

    def __init__(self, args):
        self.args = args
        # Singleton: sole instance of Log o have a single Log object
        Log.log = self

    def log(self, message):
        print message

    def debug(self, message):
        if self.args.verbose:
            print "INFO: " + message

    def info(self, message):
        print "INFO: " + message

    def warn(self, message):
        Log.log("WARN:" + message)

    def error(self, message):
        print("ERROR: " + message)

    def fatal(self, message):
        print("FATAAL: sorry, ik kap ermee want " + message)
        sys.exit(-1)

    def time(self, message=""):
        print(message + " " + strftime("%Y-%m-%d %H:%M:%S", localtime()))

    # Start (global) + print timer: useful to time for processing and optimization
    def startTimer(self, message=""):
        Log.t1 = time()
        self.info("START: " + message)

    # End (global) timer + print seconds passed: useful to time for processing and optimization
    def endTimer(self, message=""):
        self.info("END: " + message + " Duration=" + str( round( (time() - Log.t1) , 0)) + " sec")

