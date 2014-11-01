#! /usr/bin/env python

import unittest

from tags_handler import TagsHandler

class TestTagsHandler (unittest.TestCase):
    def testInstantiation(self):
        self.assertIsNotNone(TagsHandler())

    def test(self):
        None


