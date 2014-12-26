#! /usr/bin/env python

import unittest

from tags_handler import TagsHandler
from find_paths.paths_resolver import PathsResolver
from mock import patch
from mock import mock_open


from StringIO import StringIO

class TestTagsHandler (unittest.TestCase):
    def testInstantiations(self):
        handler = TagsHandler()
        self.assertTrue(handler != None)

    @patch('generate_tags.tags_handler.os')
    @patch('generate_tags.tags_handler.subprocess')
    def testExecuteCommand(self, mock_subprocess, mock_remove):
        handler = TagsHandler()

        handler.executeCommand(['some','shell', 'array'])

        mock_subprocess.call.assert_called_with(['some','shell', 'array'])

        mock_remove.remove.assert_called_once_with('.tags')
        mock_remove.rename.assert_called_once_with('.tempTags', '.tags')

        


    @patch('generate_tags.tags_handler.PathsResolver')
    def testGetCtagsCommand(self, MockPathsResolver):
        instance = MockPathsResolver.return_value
        instance.getAllSourcePaths.return_value = ['path']

        command = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        command.extend(['-f', '.tempTags'])
        command.append('path')

        result = TagsHandler().getCtagsCommand()
        self.assertEquals(command, result)




