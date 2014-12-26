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


    @patch('command_setup.grand_setup.vim')
    @patch('command_setup.grand_setup.PathsResolver')
    def testSetupJavacomplete(self, MockPathsResolver, mock_vim):
        instance = MockPathsResolver.return_value
        instance.getProjectSourcePaths.return_value = ['src/test','src/main']
        instance.getAndroidSdkJar.return_value = 'AndroidSdkJar'

        GrandSetup().setupJavacomplete()

        mock_vim.command.assert_any_call("silent! call javacomplete#SetClassPath('AndroidSdkJar')")
        mock_vim.command.assert_any_call("silent! call javacomplete#SetSourcePath(src/test:src/main:AndroidSdkJar)")


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
