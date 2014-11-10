#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
sys.modules['vim'] = VimMock()

import vim_grand_paths
from paths_resolver import PathsResolver

class TestAndroidGradle (unittest.TestCase):

    def setUp(self):
        self.vim = sys.modules['vim']


    def testSetupEnvirinmentClassPaths(self):
        paths = PathsResolver().getAllClassPaths()

        vim_grand_paths.setupEnvironmentClassPaths()

        # Note: this is of cource the reverse of the production code, but I didn't want to mock out the PathReslover
        self.assertEquals("let $CLASSPATH = '"+":".join(paths)+"'", self.vim.commandInput[0])

        #self.assertEquals("setlocal path="+",".join(paths), self.vim.commandInput[1])
        #self.assertEquals("silent! call javacomplete#SetClassPath($CLASSPATH)", self.vim.commandInput[2])
    
    
    def testSetupEnvirinmentSourcePaths(self):
        androidHome = os.environ.get('ANDROID_HOME')
        expectedString = "let $SRCPATH = './src/main/java:./src/main/res:"+androidHome+"/sources/android-19/'"

        vim_grand_paths.setupEnvironmentSourcePaths()

        self.assertEquals(expectedString, self.vim.commandInput[-2])
        self.assertEquals("silent! call javacomplete#SetSourcePath($SRCPATH)", self.vim.commandInput[-1])
