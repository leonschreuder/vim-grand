#! /usr/bin/env python

import vim
import os
import sys
from talk_to_adb.adb import Adb

class GrandInstall():

    def executeCommand(self):
        #self.installThroughAdb()

        if self.hasDispatchInstalled():
            self.installUsingDispatch()
        else:
            self.installUsingVanillaBang()

    def hasDispatchInstalled(self):
        return vim.eval("exists(':Dispatch')")

    def installUsingDispatch(self):
        vim.command('Dispatch gradle installDebug -q')

    def installUsingVanillaBang(self):
        vim.command('! gradle installDebug -q')

    def installThroughAdb(self):
        Adb().installLatestApk()
