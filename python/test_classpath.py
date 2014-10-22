#! /usr/bin/env python

import unittest

from classpath import ClassPath

class TestClassPath (unittest.TestCase):
    def setUp(self):
        self.longMessage = True

    def test_getAllClassPaths(self):
        result = ClassPath().getAllClassPaths()
        self.assertEquals(2+1+2+1, len(result))

    def test_getAllSourcePaths(self):
        # TODO build
        None
        #result = ClassPath().getAllSourcePaths()
        #self.assertEquals(500, len(result))

    def test_getProjectSources(self):
        result = ClassPath().getProjectSources()
        self.assertEqual('./src/main/java', result[0])
        self.assertEqual('./src/main/res', result[1])
        #Following path is outdated? "/build/bundles/debug/classes.jar"

    def test_getProjectBuildSources(self):
        result = ClassPath().getProjectBuildSources()
        self.assertEqual('./build/intermediates/classes/debug', result[0])

    def test_getPathsFromFile(self):
        result = ClassPath().getPathsFromFile()
        self.assertEquals(result[0], '/path/a')
        self.assertEquals(result[1], '/path/b')

    def test_getAndroidSdkJar(self):
        result = ClassPath().getAndroidSdkJar()
        self.assertEqual('/Users/laschreuder/Applications/Android/sdk/platforms/android-19/android.jar', result)

    def test_getAndroidSdkSourcePath(self):
        result = ClassPath().getAndroidSdkSourcePath()
        self.assertEqual('/Users/laschreuder/Applications/Android/sdk/sources/android-19/', result)

    def test_getAndroidVersionFromBuildGradle(self):
        result = ClassPath().getAndroidVersionFromBuildGradle()
        self.assertEquals('19', result, 'should have loaded the android version');

    def test_getAndroidVersionFromLine(self):
        result = ClassPath().getAndroidVersionFromLine("   compileSdkVersion 19");
        self.assertEqual('19', result, 'should have found the android version on the line');
        #TODO message for incorrect build.gradle?

    def test_getLibsLibraries(self):
        # classpath.vim gets built sources from "/build/bundles/debug/classes.jar"
        # Is this an option as opposed to vim.gradle file? (look into project)
        None #TODO

 
if __name__ == '__main__':
    unittest.main()
