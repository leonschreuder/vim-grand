#! /usr/bin/env python

import vim
import os
import sys

current_script_dir = vim.eval('expand("<sfile>:p:h")')
sys.path.append(current_script_dir)

from paths_resolver import PathsResolver

def setEnvirinmentClassPaths():
    resolvedClassPaths = PathsResolver().getAllClassPaths()

    # Setting $CLASSPATH variable (used by Syntastic)
    vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")

    # Adding Paths to javacomplete
    vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")


setEnvirinmentClassPaths()


#resolvedSourcePaths = PathsResolver().getAllSourcePaths()


