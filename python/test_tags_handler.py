#! /usr/bin/env python

import unittest
import os

from tags_handler import TagsHandler
from mock import patch

tagsStartString = '''!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_PROGRAM_AUTHOR	Darren Hiebert	/dhiebert@users.sourceforge.net/
!_TAG_PROGRAM_NAME	Exuberant Ctags	//
!_TAG_PROGRAM_URL	http://ctags.sourceforge.net	/official site/
!_TAG_PROGRAM_VERSION	5.8	//
'''

class TestTagsHandler (unittest.TestCase):
    def testInstantiations(self):
        handler = TagsHandler()
        self.assertTrue(handler != None)

    #def testSetupEnvirinmentClassPaths(self, MockPathsResolver):

    @patch('tags_handler.PathsResolver')
    def testGetResult(self, MockPathsResolver):
        MockPathsResolver.getAllSourcePaths.return_value = ['path']
        
        #MockPathsResolver.getAllSourcePaths.assert_called_with()
        self.assertEquals('path', TagsHandler().testResult())


    #@patch('tags_handler.PathsResolver')
    #def testGetCtagsCommand(self, MockPathsResolver):
        #MockPathsResolver.getAllSourcePaths.return_value = ['path']
        #command = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/', '-f', '.tags']

        #result = TagsHandler().getCtagsCommand()
        #self.assertEquals(command, result)

    def testVerifyTagsFile(self):
        None
        #with open('.tags','w') as f:
            #f.write(tagsStartString)

        #result = TagsHandler().isValidTagsFile();

        #self.assertTrue(result)
        #os.remove('.tags')

'''
https://docs.python.org/3/library/unittest.mock.html#the-patchers
https://docs.python.org/3/library/unittest.mock.html#where-to-patch
http://www.toptal.com/python/an-introduction-to-mocking-in-python
'''
