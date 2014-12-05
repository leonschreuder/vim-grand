#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

from vim_grand_setup import VimGrandPaths

class TestAndroidGradle (unittest.TestCase):
    


    @patch('vim_grand_setup.vim')
    @patch('vim_grand_setup.PathsResolver')
    def testSetupJavacomplete(self, MockPathsResolver, mock_vim):
        instance = MockPathsResolver.return_value
        instance.getProjectSourcePaths.return_value = ['src/test','src/main']
        instance.getAndroidSdkJar.return_value = 'AndroidSdkJar'

        VimGrandPaths().setupJavacomplete()

        mock_vim.command.assert_any_call("silent! call javacomplete#SetClassPath('AndroidSdkJar')")
        mock_vim.command.assert_any_call("silent! call javacomplete#SetSourcePath(src/test:src/main:AndroidSdkJar)")


    @patch('vim_grand_setup.vim')
    @patch('vim_grand_setup.PathsResolver')
    def testSetupSyntastic(self, MockPathsResolver, mock_vim):
        instance = MockPathsResolver.return_value
        instance.getAllClassPaths.return_value = ['path1','path2']
        #instance.getAllSourcePaths.return_value = ['source1','source2']

        VimGrandPaths().setupSyntastic()

        mock_vim.command.assert_called_once_with("let $CLASSPATH = 'path1:path2'")


