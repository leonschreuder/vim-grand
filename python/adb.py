#! /usr/bin/env python

import adb
import subprocess
import os

class Adb:
    def getDevices(self):
        androidHome = os.environ.get('ANDROID_HOME')
        #returncode = subprocess.Popen([androidHome+"/platform-tools/adb"])
        return returncode
