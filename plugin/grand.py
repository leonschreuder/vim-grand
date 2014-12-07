#! /usr/bin/env python

import vim
import os, sys


current_script_dir = vim.eval('s:script_folder_path')
print "current_script_dir", current_script_dir
sys.path.append(current_script_dir)


from setup_commands import SetupCommands

SetupCommands().execute()

#command! Grand echo "this is only a stub for autocompletion, please supply the rest of the command"

#command! GrandSetup call GrandSetup()
#function! GrandSetup()
	#call s:startPyfile("grand_setup.py")
#endfunction

#command! GrandTags call GrandTags()
#function! GrandTags()
	#call s:startPyfile("vim_grand_tags.py")
#endfunction

#command! GrandInstall call GrandInstall()
#function! GrandInstall()
	#call s:startPyfile("vim_grand_install.py")
#endfunction
