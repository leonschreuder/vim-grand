#! /usr/bin/env python

import vim

class SetupCommands():

    def execute(self):
        vim.command('command! Grand :python SetupCommands().displayEmptyCommand()')

    def displayEmptyCommand(self):
        print  'this is only a stub for autocompletion, please supply the rest of the command'

    def addCommandGrandSetup(self):
        self.setupCommandCalling('GrandSetup', 'GrandSetup().executeCommand()')

    def setupCommandCalling(self, commandNameAsString, pythonMethodAsString):
        vim.command('command! ' + commandNameAsString + ' :python ' + pythonMethodAsString)




#command! GrandTags call GrandTags()
#function! GrandTags()
	#call s:startPyfile("vim_grand_tags.py")
#endfunction

#command! GrandInstall call GrandInstall()
#function! GrandInstall()
	#call s:startPyfile("vim_grand_install.py")
#endfunction
