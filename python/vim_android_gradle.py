#! /usr/bin/env python

import vim
import os
import sys

# Look for modules in the project folder (not just cwd)
current_script_dir = vim.eval('expand("<sfile>:p:h")')
sys.path.append(current_script_dir)

from paths_resolver import PathsResolver

def setupEnvironmentClassPaths():
    resolvedClassPaths = PathsResolver().getAllClassPaths()

    # Setting $CLASSPATH variable (used by Syntastic)
    vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")

    # Adding Paths to javacomplete
    vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")

def setupEnvironmentSourcePaths():
    resolvedSourcePaths = PathsResolver().getAllSourcePaths()

    # Setting $SRCPATH variable (used by Syntastic)
    vim.command("let $SRCPATH = '" + ':'.join(resolvedSourcePaths) + "'")

    # Adding Paths to javacomplete
    vim.command("silent! call javacomplete#SetSourcePath($SRCPATH)")


setupEnvironmentClassPaths()
setupEnvironmentSourcePaths()



