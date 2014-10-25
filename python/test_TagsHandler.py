#! /usr/bin/env python

import unittest

from TagsHandler import TagsHandler
from PathsResolver import PathsResolver

# cannot test mutch in here without mocking it all out. I think it's enough :)
class test_TagsHandler (unittest.TestCase):
    def setUp(self):
        self.longMessage = True

    def test_Instantiation(self):
        self.assertIsNotNone(TagsHandler())

    def test_getCtagsCommand(self):
        result = TagsHandler().getCtagsCommand()
        stringResult = " ".join(result)

        sourcePaths = PathsResolver().getAllSourcePaths();
        self.assertEquals('ctags --recurse --fields=+l'
                +' --langdef=XML --langmap=Java:.java,XML:.xml --languages=Java,XML --regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/'
                +' -f tags'
                +' '+ ' '.join(sourcePaths)
                , stringResult, 'error in ctags or test string generation');


