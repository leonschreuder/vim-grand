#! /usr/bin/env python

import unittest
import mock_tags_handler
from vim_mock import VimMock
import sys
import os
from mock import patch

sys.modules['vim'] = VimMock()

sys.modules['tags_handler'] = mock_tags_handler

class TestGrandCtags (unittest.TestCase):

    def setUp(self):
        self.vim = sys.modules['vim']

    def testVimGrandCtagsFile(self):
        execfile('vim_grand_ctags.py')
        self.assertTrue( '/current_script_dir' in sys.path)


