#! /usr/bin/env python

import unittest
import os

from paths_resolver import PathsResolver

class TestClassPath (unittest.TestCase):
    def setUp(self):
        self.longMessage = True
        

    def testGetAllClassPaths(self):
        result = PathsResolver().getAllClassPaths()
        self.assertEquals(2+1+2+1, len(result))

    def testGetAllSourcePaths(self):
        result = PathsResolver().getAllSourcePaths()

        self.assertEquals(2+1, len(result))
        #result = PathsResolver().getAllSourcePaths()
        #self.assertEquals(500, len(result))

    def testGetProjectSourcePaths(self):
        result = PathsResolver().getProjectSourcePaths()

        self.assertEqual('./src/main/java', result[0])
        self.assertEqual('./src/main/res', result[1])
        #Following path is outdated? "/build/bundles/debug/classes.jar"

    def testGetProjectBuildSources(self):
        result = PathsResolver().getGeneratedProjectClassPaths()

        self.assertEqual('./build/intermediates/classes/debug', result[0])


    def testGetPathsFromFile(self):
        result = PathsResolver().getGradleClassPathsFromFile()

        self.assertEquals(2, len(result))
        self.assertEquals(result[0], '/path/a')
        self.assertEquals(result[1], '/path/b')

    def testGetAndroidSdkJar(self):
        result = PathsResolver().getAndroidSdkJar()

        androidHome = os.environ.get('ANDROID_HOME')
        self.assertEqual(androidHome+'/platforms/android-19/android.jar', result)

    def testGetAndroidSdkSourcePath(self):
        result = PathsResolver().getAndroidSdkSourcePath()

        androidHome = os.environ.get('ANDROID_HOME')
        self.assertEqual(androidHome + '/sources/android-19/', result)

    def testGetAndroidVersionFromBuildGradle(self):
        result = PathsResolver().getAndroidVersionFromBuildGradle()
        self.assertEquals('19', result, 'should have loaded the android version');

    def testGetAndroidVersionFromLine(self):
        result = PathsResolver().getAndroidVersionFromLine("   compileSdkVersion 19");
        self.assertEqual('19', result, 'should have found the android version on the line');
        #TODO message for incorrect build.gradle?

    def testGetLibsLibraries(self):
        # classpath.vim gets built sources from "/build/bundles/debug/classes.jar"
        # Is this an option as opposed to vim.gradle file? (look into project)
        None #TODO

 
if __name__ == '__main__':
    unittest.main()
