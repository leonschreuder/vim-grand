#! /usr/bin/env python

import vim
import os
import sys

from find_paths.paths_resolver import PathsResolver

class GrandSetup():

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

