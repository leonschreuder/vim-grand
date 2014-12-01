#! /usr/bin/env python

import vim
import os
import sys

# Add current scriptdir to import sources
current_script_dir = vim.eval('s:python_folder_path')
sys.path.append(current_script_dir)

from generate_tags.tags_handler import TagsHandler



def generateTagsAndAddToVim():
    TagsHandler().generateTagsFile()

    vim.command('silent! set tags+='+'.tags')

#generateTagsAndAddToVim()
