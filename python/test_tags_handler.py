#! /usr/bin/env python

import unittest
#import os

from tags_handler import TagsHandler
from find_paths.paths_resolver import PathsResolver
from mock import patch
from mock import mock_open
#import __builtin__

tagsStartString = '''!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_PROGRAM_AUTHOR	Darren Hiebert	/dhiebert@users.sourceforge.net/
!_TAG_PROGRAM_NAME	Exuberant Ctags	//
!_TAG_PROGRAM_URL	http://ctags.sourceforge.net	/official site/
!_TAG_PROGRAM_VERSION	5.8	//
'''

from StringIO import StringIO

class TestTagsHandler (unittest.TestCase):
    def testInstantiations(self):
        handler = TagsHandler()
        self.assertTrue(handler != None)

    @patch('tags_handler.PathsResolver')
    def testGetCtagsCommand(self, MockPathsResolver):
        instance = MockPathsResolver.return_value
        instance.getAllSourcePaths.return_value = ['path']

        command = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/', '-f', '.tags']
        command.append('path')

        result = TagsHandler().getCtagsCommand()
        self.assertEquals(command, result)


    #TODO: Test some other way.
    #@patch('__builtin__.open', mock_open(read_data='bibble'))
    #def testIsValidTagsFile(self):
    @patch('__builtin__.open')
    def testIsValidTagsFile(self, mockopen):
        pass
        #mock_open(mock=None, read_data=tagsStartString)
        #mock_open(read_data=tagsStartString)
        #instance = mockopen.return_value
        #instance.readlines.return_value = StringIO(tagsStartString)
        #mockopen.return_value = StringIO(tagsStartString)

        #with open('.tags','w') as f:
            #f.write(tagsStartString)

        result = TagsHandler().isValidTagsFile();

        self.assertTrue(result)
        #os.remove('.tags')

    def testFileIsTagsFile(self):
        file = StringIO(tagsStartString)

        result = TagsHandler().fileIsTagsFile(file)

        self.assertTrue(result)

'''
https://docs.python.org/3/library/unittest.mock.html#the-patchers
https://docs.python.org/3/library/unittest.mock.html#where-to-patch
http://www.toptal.com/python/an-introduction-to-mocking-in-python
'''
