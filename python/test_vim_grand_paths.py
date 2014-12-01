#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch

from vim_mock import VimMock
sys.modules['vim'] = VimMock()

import vim_grand_paths

class TestAndroidGradle (unittest.TestCase):

    @patch('vim_grand_paths.vim')
    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentClassPaths(self, MockPathsResolver, mock_vim):
        MockPathsResolver.return_value.getAllClassPaths.return_value = ['path1','path2']

        vim_grand_paths.setupEnvironmentClassPaths()

        mock_vim.command.assert_called_with("let $CLASSPATH = 'path1:path2'")
    

    @patch('vim_grand_paths.vim')
    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentSourcePaths(self, MockPathsResolver, mock_vim):
        MockPathsResolver.return_value.getAllSourcePaths.return_value = ['path1','path2']

        expectedString = "let $SRCPATH = 'path1:path2'"

        vim_grand_paths.setupEnvironmentSourcePaths()

        self.assertEqual(2, mock_vim.command.call_count)
        mock_vim.command.assert_any_call("let $SRCPATH = 'path1:path2'")
        mock_vim.command.assert_any_call("silent! call javacomplete#SetSourcePath($SRCPATH)")
