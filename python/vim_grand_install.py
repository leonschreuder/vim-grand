#! /usr/bin/env python

import vim
import os
import sys

# FIRST THING
# Adds current scriptdir to import sources. Then we can import as if the code was
# run from inside the script dir.
current_script_dir = vim.eval('s:python_folder_path')
sys.path.append(current_script_dir)



# This file has more than one responsibility: setting up the python
# communication, and verifying/executing the command. Put all the
# gradle/dispatch commands into a seperate class
class VimGrandInstall():

    def executeCommand(self):
        if self.hasDispatchInstalled():
            self.installUsingDispatch()

    def hasDispatchInstalled(self):
        return vim.eval("exists(':Dispatch')")

    def installUsingDispatch(self):
        vim.command('Dispatch gradle installDebug -q')

    def installUsingVanillaBang(self):
        vim.command('! gradle installDebug -q')









"""
As the entire file is run from VimScript, this fires up the class.
Because of the way python imports classes, and me wanting to use 'pyfile' for
less vimscript, we need the code in __init__ to stop the tests from running all
the code before we've had a chance to mock it all out.
"""
def isNotTest():
    return isinstance(vim.current.window.height, (int, long))


if isNotTest():
    VimGrandInstall().executeCommand();
