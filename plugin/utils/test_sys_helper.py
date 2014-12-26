#! /usr/bin/env python

import unittest
import os
import sys
import stat

from mock import patch
from sys_helper import SysHelper

class TestUtils (unittest.TestCase):

    def setUp(self):
        open('test_executable.sh', 'a', 755).close()
        os.chmod('test_executable.sh', 755)

    def tearDown(self):
        os.remove('test_executable.sh')


    def test_is_exe(self):

        result = SysHelper().is_exe('test_executable.sh')

        self.assertTrue(result)

    def test_which(self):

        result = SysHelper().which('test_executable.sh')

        self.assertEquals('test_executable.sh', result)

    def test_findFileInCwd(self):

        resultInCwd = SysHelper().fileExistsInCwd('test_executable.sh')
        resultInSubdir = SysHelper().fileExistsInCwd('sys_helper.py')
        resultNonExistent = SysHelper().fileExistsInCwd('random_file.txt')

        self.assertTrue(resultInCwd)
        self.assertTrue(resultInSubdir)
        self.assertFalse(resultNonExistent)

