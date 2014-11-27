#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
from mock import patch
from mock import MagicMock
sys.modules['vim'] = VimMock()

import vim_grand_paths
from find_paths.paths_resolver import PathsResolver

class TestAndroidGradle (unittest.TestCase):

    def setUp(self):
        None
        #self.vim = sys.modules['vim']
        #os.environ['ANDROID_HOME'] = '~/android-test-sdk'
        #os.putenv('ANDROID_HOME', '~/android-test-sdk')


    @patch('vim_grand_paths.vim')
    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentClassPaths(self, MockPathsResolver, mock_vim):
        MockPathsResolver.return_value.getAllClassPaths.return_value = ['path1','path2']
        #mock_vim.return_value.getAllClassPaths.return_value = ['path1','path2']


        vim_grand_paths.setupEnvironmentClassPaths()

        mock_vim.command.assert_called_with("let $CLASSPATH = 'path1:path2'")

        # Note: this is of cource the reverse of the production code, but I didn't want to mock out the PathReslover
        #self.assertEquals("let $CLASSPATH = 'path1:path2'", self.vim.commandInput[-1])
        #self.assertEquals("let $CLASSPATH = '"+":".join(['path'])+"'", self.vim.commandInput[0])
        #self.assertEquals("let $CLASSPATH = 'path'", self.vim.commandInput[0])

        #self.assertEquals("setlocal path="+",".join(paths), self.vim.commandInput[1])
        #self.assertEquals("silent! call javacomplete#SetClassPath($CLASSPATH)", self.vim.commandInput[2])
    
    
    @patch('vim_grand_paths.vim')
    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentSourcePaths(self, MockPathsResolver, mock_vim):
        MockPathsResolver.return_value.getAllSourcePaths.return_value = ['path1','path2']

        expectedString = "let $SRCPATH = 'path1:path2'"

        vim_grand_paths.setupEnvironmentSourcePaths()

        self.assertEqual(2, mock_vim.command.call_count)
        mock_vim.command.assert_any_call("let $SRCPATH = 'path1:path2'")
        mock_vim.command.assert_any_call("silent! call javacomplete#SetSourcePath($SRCPATH)")
        #mock_vim.command.assert_called_with("let $CLASSPATH = 'path1:path2'")

        #self.assertEquals(expectedString, self.vim.commandInput[-2])
        #self.assertEquals("silent! call javacomplete#SetSourcePath($SRCPATH)", self.vim.commandInput[-1])
