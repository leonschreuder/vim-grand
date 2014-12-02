#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch

from vim_mock import VimMock
sys.modules['vim'] = VimMock()

import vim_grand_tags

class TestGrandTags (unittest.TestCase):

    #@unittest.skip("Failing for no good reason")
    @patch('vim_grand_tags.vim')
    @patch('vim_grand_tags.TagsHandler.generateTagsFile')
    def testVimGrandCtagsFile(self, mock_generateTagsFile, mock_vim):

        vim_grand_tags.executeCommand()

        mock_generateTagsFile.assert_called_with() #Doesn't work, but why not?
        mock_vim.command.assert_called_once_with('silent! set tags+='+'.tags')


