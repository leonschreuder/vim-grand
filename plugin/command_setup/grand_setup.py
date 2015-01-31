#! /usr/bin/env python

import vim
import os
import sys

from find_paths.paths_resolver import PathsResolver
from utils.sys_helper import SysHelper
from setup_commands import SetupCommands

class GrandSetup():

    def executeCommand(self):
        if self.isGradleProject() and self.isAndroidProject():
            SetupCommands().addAllCommands()
            self.setupJavacomplete()
            self.setupSyntastic()
        else:
            print 'No gradle and/or android project detected. Is cwd set correctly?'

    def setupJavacomplete(self):
        resolver = PathsResolver()

        jarsString = resolver.getAndroidSdkJar()
        sourcePaths = resolver.getProjectSourcePaths();
        sourcePaths.append(jarsString);
        sourcesString = ':'.join(sourcePaths)

        vim.command("silent! call javacomplete#SetClassPath('" + jarsString + "')")
        vim.command("silent! call javacomplete#SetSourcePath('" + sourcesString + "')")

    def setupSyntastic(self):
        resolvedClassPaths = PathsResolver().getAllClassPaths()
        vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")
        #vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")

    def isGradleProject(self):
        return SysHelper().fileExistsInCwd("build.gradle")

    def isAndroidProject(self):
        return SysHelper().fileExistsInCwd("AndroidManifest.xml")

