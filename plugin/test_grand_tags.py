#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch
from mock import MagicMock

# We don't actually use this mock, but otherwise python can't find the vim
# module at all because it is only available when run from vim
sys.modules['vim'] = MagicMock() 

from grand_tags import GrandTags

class TestGrandTags (unittest.TestCase):

    @patch('grand_tags.vim')
    @patch('grand_tags.TagsHandler.generateTagsFile')
    def testVimGrandCtagsFile(self, mock_generateTagsFile, mock_vim):

        GrandTags().executeCommand()

        mock_generateTagsFile.assert_called_with()
        mock_vim.command.assert_called_once_with('silent! set tags+='+'.tags')


