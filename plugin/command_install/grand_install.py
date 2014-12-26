#! /usr/bin/env python

import vim
import os
import sys


class GrandInstall():

    def executeCommand(self):
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
