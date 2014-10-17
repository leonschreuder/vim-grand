#! /usr/bin/env python

import unittest

from classpath import ClassPath

class TestClassPath (unittest.TestCase):
    def test_getStaticClassPaths(self):
        result = ClassPath().getStaticClassPaths()
        assert result == './src/main/java:./build/intermediates/classes/debug'

    def test_getPathsFromFile(self):
        result = ClassPath().getPathsFromFile()
        self.assertEquals(result, '/path/a:/path/b')
        assert result == '/path/a:/path/b'
 
if __name__ == '__main__':
    unittest.main()
