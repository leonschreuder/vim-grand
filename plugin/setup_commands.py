#! /usr/bin/env python


import vim

class SetupCommands():

    def execute(self):
        vim.command('command! Grand :python SetupCommands().displayEmptyCommand()')

    def displayEmptyCommand(self):
        print  'this is only a stub for autocompletion, please supply the rest of the command'


#command! Grand echo "this is only a stub for autocompletion, please supply the rest of the command"

#command! GrandSetup call GrandSetup()
#function! GrandSetup()
	#call s:startPyfile("vim_grand_setup.py")
#endfunction

#command! GrandTags call GrandTags()
#function! GrandTags()
	#call s:startPyfile("vim_grand_tags.py")
#endfunction

#command! GrandInstall call GrandInstall()
#function! GrandInstall()
	#call s:startPyfile("vim_grand_install.py")
#endfunction
