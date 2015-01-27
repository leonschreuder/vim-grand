#! /usr/bin/env python

from utils.sys_helper import SysHelper

import vim

class Gradle:
    GRADLE = 'gradle'
    GRADLE_WRAPPER = './gradlew'
    DISPATCH = 'Dispatch'

    def __init__(self):
        self.sysHelper = SysHelper()

    def executeGradleCommand(self, command):
        gradleExe = self.GRADLE
        if self.hasGradleWrapper():
            gradleExe = self.GRADLE_WRAPPER

        commandRunner = '!'
        if self.hasDispatchInstalled():
            commandRunner = self.DISPATCH

        vim.command(commandRunner + ' ' + gradleExe + ' '+command+' -q')

    def hasGradle(self):
        return self.sysHelper.which(self.GRADLE) != None

    def hasGradleWrapper(self):
        return self.sysHelper.which(self.GRADLE_WRAPPER) != None

    def hasDispatchInstalled(self):
        return vim.eval("exists(':"+self.DISPATCH+"')")
