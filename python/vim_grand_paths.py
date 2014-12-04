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
        self.addCurrentScriptdirToImportSources()

        self.setupJavacomplete()
        self.setupSyntastic()

    def addCurrentScriptdirToImportSources(self):
        # Add current scriptdir to import sources
        current_script_dir = vim.eval('s:python_folder_path')
        sys.path.append(current_script_dir)

    def setupJavacomplete(self):
        resolver = PathsResolver()

        jarsString = resolver.getAndroidSdkJar()
        sourcesString = ':'.join(resolver.getProjectSourcePaths())

        vim.command("silent! call javacomplete#SetClassPath('" + jarsString + "')")
        vim.command("silent! call javacomplete#SetSourcePath(" + sourcesString + ")")

    def setupSyntastic(self):
        resolvedClassPaths = PathsResolver().getAllClassPaths()
        vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")
        #vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")


    #DELETE ME
    def oldExecuteCommand(self):
        self.addCurrentScriptdirToImportSources()

        self.setupEnvironmentClassPaths()
        self.setupEnvironmentSourcePaths()

    #DELETE ME
    def setupEnvironmentClassPaths(self):
        resolvedClassPaths = PathsResolver().getAllClassPaths()

        #print 'resolved paths: ', resolvedClassPaths

        self.setClassPathVariable(resolvedClassPaths) # used by Syntastic?

        #Don't readly know what this is used for.
        #setLocalPathVariable(resolvedClassPaths)

        #Javacomplete seems to already use the $CLASSPATH direcly
        #addClasspathToJavacomplete() 

    #DELETE ME
    def setClassPathVariable(self, paths):
        vim.command("let $CLASSPATH = '" + ':'.join(paths) + "'")

    #DELETE ME
    def setLocalPathVariable(self, paths):
        # TODO don't realy know what this is used for. Syntastic? So test it out...
        vim.command("setlocal path=" + ','.join(paths))

    #DELETE ME
    def addClasspathToJavacomplete(self):
        vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")



    #DELETE ME
    def setupEnvironmentSourcePaths(self):
        resolvedSourcePaths = PathsResolver().getAllSourcePaths()

        self.setSourcePathVariable(resolvedSourcePaths) # used by Syntastic?
        self.addSourcepathToJavacomplete()

    #DELETE ME
    def setSourcePathVariable(self, paths):
        vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")

    #DELETE ME
    def addSourcepathToJavacomplete(self):
        vim.command("silent! call javacomplete#SetSourcePath($SRCPATH)")


# As the entire file is executed from VimScript this call fires up python to
# take over without any VimScript interaction. This is not very clean, but
# removes the need for untested python-code or VimScripting and relieves the
# need to jump through strange illogical hoops in the unit Tests just to make
# sure it all works.
VimGrandPaths().executeCommand()


