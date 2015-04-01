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


# IntelliJ porcess:

#Target device: samsung-nexus_10-R32D202RWKA
#Uploading file
    #local path: /Users/lschreuder/Documents/workspace/50hertz_app/build/outputs/apk/50hertz_app-debug-1.1.2.apk
        #remote path: /data/local/tmp/de.fuenfzig_hertz.eeg_app
        #Installing de.fuenfzig_hertz.eeg_app
        #DEVICE SHELL COMMAND: pm install -r "/data/local/tmp/de.fuenfzig_hertz.eeg_app"
        #pkg: /data/local/tmp/de.fuenfzig_hertz.eeg_app
        #Success


        #Launching application: de.fuenfzig_hertz.eeg_app/de.fuenfzig_hertz.eeg_app.MainActivity.
        #DEVICE SHELL COMMAND: am start -n "de.fuenfzig_hertz.eeg_app/de.fuenfzig_hertz.eeg_app.MainActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
        #Starting: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] cmp=de.fuenfzig_hertz.eeg_app/.MainActivity }
