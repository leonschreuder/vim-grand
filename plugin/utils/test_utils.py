#! /usr/bin/env python

import unittest
import os
import sys
import stat

from mock import patch
from utils import Utils

class TestUtils (unittest.TestCase):

    def setUp(self):
        open('build/test_executable.sh', 'a', 755).close()
        os.chmod('build/test_executable.sh', 755)

    def tearDown(self):
        os.remove('build/test_executable.sh')


    def test_is_exe2(self):

        result = Utils().is_exe('build/test_executable.sh')

        self.assertTrue(result)

    def test_which(self):

        result = Utils().which('build/test_executable.sh')

        self.assertEquals('build/test_executable.sh', result)
