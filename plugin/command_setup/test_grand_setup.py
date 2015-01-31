#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

from command_setup.grand_setup import GrandSetup

class TestGrandSetup (unittest.TestCase):

    @patch('command_setup.grand_setup.SetupCommands')
    @patch('command_setup.grand_setup.SysHelper')
    @patch('command_setup.grand_setup.vim')
    def testExecuteCommand(self, mock_vim, MockSysHelper, MockSetupCommands):
        MockSysHelper.return_value.fileExistsInCwd.return_value = True
        gradSetup = GrandSetup()
        gradSetup.pathsResolver = MockPathsResolver()
        
        gradSetup.executeCommand()

        mock_vim.command.assert_any_call("let $CLASSPATH = 'path1:path2'")
        MockSetupCommands.return_value.addAllCommands.assert_called_with()

    @patch('command_setup.grand_setup.vim')
    def testSetupJavacomplete(self, mock_vim):
        gradSetup = GrandSetup()
        gradSetup.pathsResolver = MockPathsResolver()

        gradSetup.setupJavacomplete()

        mock_vim.command.assert_any_call("silent! call javacomplete#SetClassPath('AndroidSdkJar:src/test:src/main')")
        mock_vim.command.assert_any_call("silent! call javacomplete#SetSourcePath('src/test:src/main:AndroidSdkJar')")


    @patch('command_setup.grand_setup.vim')
    @patch('command_setup.grand_setup.PathsResolver')
    def testSetupSyntastic(self, MockPathsResolver, mock_vim):
        instance = MockPathsResolver.return_value
        instance.getAllClassPaths.return_value = ['path1','path2']

        GrandSetup().setupSyntastic()

        mock_vim.command.assert_called_once_with("let $CLASSPATH = 'path1:path2'")

    @patch('command_setup.grand_setup.SysHelper')
    def testIsGradleProject(self, mock_sys_helper):
        mockedMethod = mock_sys_helper.return_value.fileExistsInCwd

        GrandSetup().isGradleProject()

        mockedMethod.assert_called_with('build.gradle')


    @patch('command_setup.grand_setup.SysHelper')
    def testIsAndroidProject(self, mock_sys_helper):
        mockedMethod = mock_sys_helper.return_value.fileExistsInCwd

        GrandSetup().isAndroidProject()

        mockedMethod.assert_called_with('AndroidManifest.xml')


class MockPathsResolver():
    def getAllClassPaths(self):
        return ['path1','path2']
    def getExplodedAarClasses(self):
        return ['src/test','src/main']
    def getAndroidSdkJar(self):
        return 'AndroidSdkJar'
    def getProjectSourcePaths(self):
        return ['src/test','src/main']

