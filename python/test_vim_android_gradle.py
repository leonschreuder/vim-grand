#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
sys.modules['vim'] = VimMock()

import vim_android_gradle

class TestAndroidGradle (unittest.TestCase):

    def testSettingClassPathsVar(self):
        vim = sys.modules['vim']

        vim_android_gradle.setEnvirinmentClassPaths()

        androidHome = os.environ.get('ANDROID_HOME')
        expectedString = "let $CLASSPATH = './src/main/java:./src/main/res:./build/intermediates/classes/debug:/path/a:/path/b:"+androidHome+"/platforms/android-19/android.jar'"
        self.assertEquals(expectedString, vim.commandInput[0])
        self.assertEquals("silent! call javacomplete#SetClassPath($CLASSPATH)", vim.commandInput[1])

        self.assertFalse(True) #This class needs more tests

        #vim.command("silent! call javacomplete#SetClassPath($CLASSPATH)")
    
