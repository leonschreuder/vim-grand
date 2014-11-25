#! /usr/bin/env python

import unittest
import os
from mock import patch

from adb import Adb

TEST_ANDROID_HOME = 'TEST_ANDROID_HOME'

class TestAdb (unittest.TestCase):
    def setUp(self):
        self.longMessage = True
        os.environ['ANDROID_HOME'] = TEST_ANDROID_HOME


    def testInit(self):
        self.assertIsNotNone(Adb())


    def testGetAdb(self):
        result = Adb().getAdb()

        self.assertEquals(TEST_ANDROID_HOME+'/platform-tools/adb', result)

        
    @patch('adb.subprocess')
    def testGetDevices(self, mock_subprocess):

        result = Adb().getDevices()

        mock_subprocess.Popen.assert_called_with(['TEST_ANDROID_HOME/platform-tools/adb', 'devices'])
