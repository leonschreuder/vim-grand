#! /usr/bin/env python

import unittest
import os

from paths_resolver import PathsResolver

ANDROID_HOME = 'TEST_ANDROID_HOME'

class TestClassPath (unittest.TestCase):

    def setUp(self):
        self.longMessage = True
        os.environ['ANDROID_HOME'] = ANDROID_HOME

    # Just to see if the setting of the environment variable works for testing
    def testSetsAndroidHome(self):
        result = PathsResolver().getAndroidHome();

        self.assertEquals(ANDROID_HOME, result)

    def testGetAllClassPaths(self):
        result = PathsResolver().getAllClassPaths()

        self.assertEquals(2+1+2+1+2, len(result))

    def testGetAllSourcePaths(self):
        result = PathsResolver().getAllSourcePaths()

        self.assertEquals(2+1, len(result))


    def testGetProjectSourcePaths(self):
        result = PathsResolver().getProjectSourcePaths()

        self.assertEqual('./src/main/java', result[0])
        self.assertEqual('./src/main/res', result[1])

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

        self.assertEqual(ANDROID_HOME+'/platforms/android-19/android.jar', result)


    def testGetAndroidSdkSourcePath(self):
        result = PathsResolver().getAndroidSdkSourcePath()

        self.assertEqual(ANDROID_HOME + '/sources/android-19/', result)


    def testGetAndroidVersionFromBuildGradle(self):
        result = PathsResolver().getAndroidVersionFromBuildGradle()

        self.assertEquals('19', result, 'should have loaded the android version');


    def testGetAndroidVersionFromLine(self):
        result = PathsResolver().getAndroidVersionFromLine("   compileSdkVersion 19");

        self.assertEqual('19', result, 'should have found the android version on the line');
        #TODO message for incorrect build.gradle?


    def testGetExplodedAarClasses(self):
        result = PathsResolver().getExplodedAarClasses()

        self.assertEquals('./build/intermediates/exploded-arr/fakeJar.jar', result[0])
        self.assertEquals('./build/intermediates/exploded-arr/some_project/fakeJar2.jar', result[1])


    def testGetLatestApkFile(self):
        testFile = './build/apk/some.apk'
        self.createTestFile(testFile)

        result = PathsResolver().getLatestApkFile()

        self.assertEquals('./build/apk/some.apk', result)

        self.removeTestFile(testFile)


    def createTestFile(self, filePath):
        basedir = os.path.dirname(filePath)
        if not os.path.exists(basedir):
            os.makedirs(basedir)

        open(filePath, 'w').close()

    def removeTestFile(self, filePath):
        os.remove(filePath)

        basedir = os.path.dirname(filePath)
        if not os.listdir(basedir):
            os.rmdir(basedir)

        #TODO: Delete all created sub-dirs










 
if __name__ == '__main__':
    unittest.main()
