#! /usr/bin/env python

import unittest

from classpath import ClassPath

class TestClassPath (unittest.TestCase):
    def test_getQuestionListFromFile(self):
        classpath = ClassPath()
        result = classpath.getClassPaths()
        assert result == './src/main/java:./build/intermediates/classes/debug:/Users/some/file/path/from/file'
