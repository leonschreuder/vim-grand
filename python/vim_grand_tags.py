#! /usr/bin/env python

import vim
import os
import sys

# Add current scriptdir to import sources
current_script_dir = vim.eval('s:python_folder_path')
sys.path.append(current_script_dir)

from generate_tags.tags_handler import TagsHandler

class VimGrandTags():

    def executeCommand(self):
        self.generateTagsAndAddToVim()


    def generateTagsAndAddToVim(self):
        TagsHandler().generateTagsFile()

        vim.command('silent! set tags+='+'.tags')


# As the entire file is executed from VimScript this call fires up python to
# take over without any VimScript interaction. This is not very clean, but
# removes the need for untested python-code or VimScripting and relieves the
# need to jump through strange illogical hoops in the unit Tests just to make
# sure it all works.
VimGrandTags().executeCommand()
