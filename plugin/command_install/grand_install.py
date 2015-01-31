#! /usr/bin/env python

import vim
import os
import sys
from talk_to_adb.adb import Adb
from talk_to_gradle.gradle import Gradle

class GrandInstall():

    def executeCommand(self):
        Gradle().executeGradleCommand('installDebug')
        #self.installThroughAdb()

        #if self.hasDispatchInstalled():
            #self.installUsingDispatch()
        #else:
            #self.installUsingVanillaBang()

    def hasDispatchInstalled(self):
        return vim.eval("exists(':Dispatch')")

    def installUsingDispatch(self):
        vim.command('Dispatch gradle installDebug -q')
        #vim.command('Dispatch ./gradlew installDebug -q')
        #TODO: this needs to be implemented correclty.

    def installUsingVanillaBang(self):
        vim.command('! gradle installDebug -q')

    def installThroughAdb(self):
        Adb().installLatestApk()
