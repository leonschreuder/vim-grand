#! /usr/bin/env python

import unittest
from vim_mock import VimMock
import sys
import os
sys.modules['vim'] = VimMock()

#sys.modules['tags_handler'] = MockTagsHandler

class TestGrandCtags (unittest.TestCase):

    def setUp(self):
        self.vim = sys.modules['vim']

    def testVimGrandCtagsFile(self):
        # TODO could not get the simple mocking of 'from filename import class'
        # to use the below mock version and I didn't want to create an entrire
        # file for it. Without mocking the class will just generate the ctags
        # file. Which I don't want to wait for (or cancel) every test run.
        None

        #execfile('vim_grand_ctags.py')
        #self.assertTrue( '/current_script_dir' in sys.path)


class MockTagsHandler:
    def generateTagsFile(self):
        self.generateTagsFileCalled = True

