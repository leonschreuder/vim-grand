#! /usr/bin/env python

import vim
import os
import sys

from find_paths.paths_resolver import PathsResolver
from utils.sys_helper import SysHelper
from setup_commands import SetupCommands

class GrandSetup():
    def __init__(self):
        self.pathsResolver = PathsResolver()

    def executeCommand(self):
        if self.isGradleProject() and self.isAndroidProject():
            SetupCommands().addAllCommands()
            self.setupJavacomplete()
            self.setupSyntastic()
        else:
            print 'No gradle and/or android project detected. Is cwd set correctly?'

    def setupJavacomplete(self):
        jarsPaths = []
        jarsPaths.append(self.pathsResolver.getAndroidSdkJar())
        jarsPaths.extend(self.pathsResolver.getExplodedAarClasses())
        jarsPaths.extend(self.pathsResolver.getGeneratedProjectClassPaths())
        jarsPaths.extend(self.pathsResolver.getGradleClassPathsFromFile())

        sourcePaths = self.pathsResolver.getProjectSourcePaths()
        sourcePaths.append(self.pathsResolver.getAndroidSdkJar())
        sourcePaths.extend(self.pathsResolver.getGradleClassPathsFromFile())


        jarsString = ':'.join(jarsPaths)
        sourcesString = ':'.join(sourcePaths)

        vim.command("silent! call javacomplete#SetClassPath('" + jarsString + "')")
        vim.command("silent! call javacomplete#SetSourcePath('" + sourcesString + "')")

    def setupSyntastic(self):
        resolvedClassPaths = self.pathsResolver.getAllClassPaths()
        vim.command("let $CLASSPATH = '" + ':'.join(resolvedClassPaths) + "'")
        #vim.command("let $SRCPATH = '" + ':'.join(paths) + "'")

    def isGradleProject(self):
        return SysHelper().fileExistsInCwd("build.gradle")

    def isAndroidProject(self):
        return SysHelper().fileExistsInCwd("AndroidManifest.xml")

