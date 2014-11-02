#! /usr/bin/env python

import vim
import os
import sys

# Look for modules in the project folder (not just cwd)
# TODO: Doesn't work inside function
#current_script_dir = vim.eval('expand("<sfile>:p:h")')

current_script_dir = vim.eval('s:python_folder_path')
sys.path.append(current_script_dir)



from paths_resolver import PathsResolver

def setupEnvironmentClassPaths():
    resolvedClassPaths = PathsResolver().getAllClassPaths()

    setClassPathVariable(resolvedClassPaths) # used by Syntastic?
    setLocalPathVariable(resolvedClassPaths)
    addClasspathToJavacomplete()

def setClassPathVariable(paths):
    vim.command("let $CLASSPATH = '" + ':'.join(paths) + "'")

def setLocalPathVariable(paths):
    # TODO
    # Realy don't know what this is used for. Is it for syntastic?
    vim.command("setlocal path=" + ','.join(paths))

def addClasspathToJavacomplete():
    vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")



def setupEnvironmentSourcePaths():
    resolvedSourcePaths = PathsResolver().getAllSourcePaths()

    setSourcePathVariable(resolvedSourcePaths) # used by Syntastic?
    addSourcepathToJavacomplete()

def setSourcePathVariable(paths):
    vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")

def addSourcepathToJavacomplete():
    vim.command("silent! call javacomplete#SetSourcePath($SRCPATH)")


setupEnvironmentClassPaths()
setupEnvironmentSourcePaths()



