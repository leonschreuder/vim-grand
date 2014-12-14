#! /usr/bin/env python

import adb
import subprocess
import os

from find_paths.paths_resolver import PathsResolver

class Adb:
    def getDevices(self):
        returncode = subprocess.Popen([self.getAdb(), 'devices'])
        return returncode

    def getAdb(self):
        androidHome = os.environ.get('ANDROID_HOME')
        return androidHome +os.sep+ "platform-tools" +os.sep+ "adb"

    def installLatestApk(self):
        apkFile = PathsResolver().getLatestApkFile()
        returncode = subprocess.Popen([self.getAdb(), 'install', '-r', apkFile])

