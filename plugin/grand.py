#! /usr/bin/env python

import vim
import os, sys


# python will be started from the python's installation location, this adds the
# previously saved current script dir to the path so we can import stuff
current_script_dir = vim.eval('s:script_folder_path')
sys.path.append(current_script_dir)


# I don't want to do untested stuff here,
# so just call through to the tested SetupCommands
from setup_commands import SetupCommands
SetupCommands().execute()
