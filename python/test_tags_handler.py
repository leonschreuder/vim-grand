#! /usr/bin/env python

import unittest

from tags_handler import TagsHandler

class TestTagsHandler (unittest.TestCase):
    def testInstantiation(self):
        None
        #self.assertIsNotNone(TagsHandler())

    def testGetCtagsCommand(self):
        None
        #command = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/', '.tags']


