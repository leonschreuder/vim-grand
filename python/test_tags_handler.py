#! /usr/bin/env python

import unittest
import os

from tags_handler import TagsHandler

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

    def testGetCtagsCommand(self):
        None
        #command = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/', '.tags']

    def testVerifyTagsFile(self):
        with open('.tags','w') as f:
            f.write(tagsStartString)

        result = TagsHandler().isValidTagsFile();

        self.assertTrue(result)
        os.remove('.tags')


