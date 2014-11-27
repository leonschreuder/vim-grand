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
        self.vim = sys.modules['vim']
        #os.environ['ANDROID_HOME'] = '~/android-test-sdk'
        #os.putenv('ANDROID_HOME', '~/android-test-sdk')


    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentClassPaths(self, MockPathsResolver):
        instance = MockPathsResolver.return_value
        instance.getAllClassPaths.return_value = ['path1','path2']

        vim_grand_paths.setupEnvironmentClassPaths()

        # Note: this is of cource the reverse of the production code, but I didn't want to mock out the PathReslover
        self.assertEquals("let $CLASSPATH = 'path1:path2'", self.vim.commandInput[-1])
        #self.assertEquals("let $CLASSPATH = '"+":".join(['path'])+"'", self.vim.commandInput[0])
        #self.assertEquals("let $CLASSPATH = 'path'", self.vim.commandInput[0])

        #self.assertEquals("setlocal path="+",".join(paths), self.vim.commandInput[1])
        #self.assertEquals("silent! call javacomplete#SetClassPath($CLASSPATH)", self.vim.commandInput[2])
    
    
    @patch('vim_grand_paths.PathsResolver')
    def testSetupEnvirinmentSourcePaths(self, MockPathsResolver):
        instance = MockPathsResolver.return_value
        instance.getAllSourcePaths.return_value = ['path1','path2']

        expectedString = "let $SRCPATH = 'path1:path2'"

        vim_grand_paths.setupEnvironmentSourcePaths()

        self.assertEquals(expectedString, self.vim.commandInput[-2])
        self.assertEquals("silent! call javacomplete#SetSourcePath($SRCPATH)", self.vim.commandInput[-1])
