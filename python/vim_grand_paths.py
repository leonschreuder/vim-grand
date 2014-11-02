#! /usr/bin/env python

import vim
import os
import sys

# Add current scriptdir to import sources
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
    # TODO don't realy know what this is used for. Syntastic? So test it out...
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



