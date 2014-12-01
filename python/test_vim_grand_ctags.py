#! /usr/bin/env python

import unittest
import sys
import os
from mock import patch

from vim_mock import VimMock
sys.modules['vim'] = VimMock()

import vim_grand_ctags

class TestGrandCtags (unittest.TestCase):

    #@unittest.skip("Failing for no good reason")
    @patch('vim_grand_ctags.vim')
    @patch('vim_grand_ctags.TagsHandler.generateTagsFile')
    def testVimGrandCtagsFile(self, mock_generateTagsFile, mock_vim):
        print "should work"

        vim_grand_ctags.generateTagsAndAddToVim()

        mock_generateTagsFile.assert_called_with() #Doesn't work, but why not?
        mock_vim.command.assert_called_once_with('silent! set tags+='+'.tags')


