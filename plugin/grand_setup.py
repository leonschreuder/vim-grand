#! /usr/bin/env python

import vim
import os
import sys

current_script_dir = vim.eval('s:python_folder_path')
sys.path.append(current_script_dir)

from find_paths.paths_resolver import PathsResolver

#Class is started up below
class VimGrandPaths():

    def executeCommand(self):

        self.setupJavacomplete()
        self.setupSyntastic()

    def setupJavacomplete(self):
        resolver = PathsResolver()

        jarsString = resolver.getAndroidSdkJar()
        sourcePaths = resolver.getProjectSourcePaths();
        sourcePaths.append(jarsString);
        sourcesString = ':'.join(sourcePaths)

        print sourcesString

        vim.command("silent! call javacomplete#SetClassPath('" + jarsString + "')")
        vim.command("silent! call javacomplete#SetSourcePath(" + sourcesString + ")")

    def setupSyntastic(self):
        resolvedClassPaths = PathsResolver().getAllClassPaths()
        vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")
        #vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")







"""
As the entire file is run from VimScript, this fires up the class.
Because of the way python imports classes, and me wanting to use 'pyfile' for
less vimscript, we need the code in __init__ to stop the tests from running all
the code before we've had a chance to mock it all out.
"""
def isNotTest():
    return isinstance(vim.current.window.height, (int, long))


if isNotTest():
    VimGrandPaths().executeCommand();
