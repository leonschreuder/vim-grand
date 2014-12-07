#! /usr/bin/env python

import vim
import re

class SetupCommands():

    def execute(self):
        self.addCommandGrandSetup()
        self.addCommandGrandTags()
        self.addCommandGrandInstall()

        vim.command('command! Grand :python SetupCommands().displayEmptyCommand()')


    def displayEmptyCommand(self):
        print  'this is only a stub for autocompletion, please supply the rest of the command'


    def addCommandGrandSetup(self):
        self.setupCommandCalling('GrandSetup')

    def addCommandGrandTags(self):
        self.setupCommandCalling('GrandTags')

    def addCommandGrandInstall(self):
        self.setupCommandCalling('GrandInstall')


    def setupCommandCalling(self, commandNameAsString):
        fileName = self.convertCamelToSnake(commandNameAsString)

        #We need to explicitly import the class we want to call in vim itself apperantly
        vim.command(':python from ' + fileName + ' import ' + commandNameAsString)
        #Add the command that calls executeCommand() on the specified class
        vim.command('command! ' + commandNameAsString + ' :python ' + commandNameAsString + '().executeCommand()')

    def convertCamelToSnake(self, name):
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
