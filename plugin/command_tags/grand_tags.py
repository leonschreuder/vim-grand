#! /usr/bin/env python

import vim
import os
import sys



from generate_tags.tags_handler import TagsHandler

class GrandTags():

    def executeCommand(self):
        self.generateTagsAndAddToVim()

    def generateTagsAndAddToVim(self):
        TagsHandler().generateTagsFile()

        # TODO: Move to GrandSetup
        vim.command('silent! set tags+='+'.tags')
