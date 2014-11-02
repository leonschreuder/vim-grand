#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
sys.modules['vim'] = VimMock()

import vim_android_gradle

class TestAndroidGradle (unittest.TestCase):

    def setUp(self):
        self.vim = sys.modules['vim']


    def testSetupEnvirinmentClassPaths(self):
        androidHome = os.environ.get('ANDROID_HOME')
        expectedString = "let $CLASSPATH = './src/main/java:./src/main/res:./build/intermediates/classes/debug:/path/a:/path/b:"+androidHome+"/platforms/android-19/android.jar'"

        vim_android_gradle.setupEnvironmentClassPaths()

        self.assertEquals(expectedString, self.vim.commandInput[0])
        self.assertEquals("setlocal path=./src/main/java,./src/main/res,./build/intermediates/classes/debug,/path/a,/path/b,"+androidHome+"/platforms/android-19/android.jar", self.vim.commandInput[1])
        self.assertEquals("silent! call javacomplete#SetClassPath($CLASSPATH)", self.vim.commandInput[2])

        #vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")
    
    
    def testSetupEnvirinmentSourcePaths(self):
        androidHome = os.environ.get('ANDROID_HOME')
        expectedString = "let $SRCPATH = './src/main/java:./src/main/res:"+androidHome+"/sources/android-19/'"

        vim_android_gradle.setupEnvironmentSourcePaths()

        self.assertEquals(expectedString, self.vim.commandInput[-2])
        self.assertEquals("silent! call javacomplete#SetSourcePath($SRCPATH)", self.vim.commandInput[-1])
