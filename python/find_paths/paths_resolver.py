#! /usr/bin/env python

import re
import os
import sys
import glob

class PathsResolver:
    def __init__(self):
        sys.path.append(os.getcwd())

    def getAndroidHome(self):
        return os.environ.get('ANDROID_HOME')

    def getAllClassPaths(self):
        classPathsAndJars = []

        classPathsAndJars.extend(self.getProjectSourcePaths()) # Does syntastic need this?
        classPathsAndJars.extend(self.getGeneratedProjectClassPaths())
        classPathsAndJars.extend(self.getGradleClassPathsFromFile())
        classPathsAndJars.append(self.getAndroidSdkJar())
        classPathsAndJars.extend(self.getExplodedAarClasses())
        return classPathsAndJars

    def getAllSourcePaths(self):
        sourcePaths = []
        sourcePaths.extend(self.getProjectSourcePaths())
        sourcePaths.append(self.getAndroidSdkSourcePath()) #TODO This messes up javacomplete. Why?
        return sourcePaths


    def getProjectSourcePaths(self):
        projectClassPath = './src/main/java'
        projectResPath = './src/main/res'
        return [projectClassPath, projectResPath]

    def getGeneratedProjectClassPaths(self):
        generatedDebugClasses =  './build/intermediates/classes/debug'
        return [generatedDebugClasses]


    def getGradleClassPathsFromFile(self):
        list = []

        filename = 'gradle-sources'

        if (os.path.isfile(filename)):
            with open(filename, 'U') as f:
                for line in f:
                    list.append(line.rstrip())
        return list

    def getAndroidSdkJar(self):
        androidHome = os.environ.get('ANDROID_HOME')
        currentPlatformDir = 'android-' + self.getAndroidVersionFromBuildGradle()

        sdkJarPath = androidHome +os.sep+ 'platforms' +os.sep+ currentPlatformDir +os.sep+ 'android.jar'
        return sdkJarPath

    def getAndroidSdkSourcePath(self):
        androidHome = os.environ.get('ANDROID_HOME')
        currentPlatformDir = 'android-' + self.getAndroidVersionFromBuildGradle()

        sdkSourcePath = androidHome +os.sep+ 'sources' +os.sep+ currentPlatformDir +os.sep
        return sdkSourcePath


    def getAndroidVersionFromBuildGradle(self):
        with open('build.gradle', 'U') as f:
            for line in f:
                result = self.getAndroidVersionFromLine(line)
                if (result != None):
                    return result

    def getAndroidVersionFromLine(self, line):
        matchObj = re.search( r'compileSdkVersion\W*(\d*)', line, re.M|re.I)
        if matchObj != None:
            version = matchObj.group(1)
            return version
        return None

    def getExplodedAarClasses(self):
        foundJars = []
        for root, dirs, files in os.walk("./"):
            for file in files:
                if file.endswith(".jar"):
                    foundJars.append(os.path.join(root, file))
                    #print(os.path.join(root, file))
        return foundJars

    def getLatestApkFile(self):
        foundFiles = []
        for root, dirs, files in os.walk("./build/"):
            for file in files:
                if file.endswith(".apk"):
                    foundFiles.append(os.path.join(root, file))

        #TODO cannot test this becouse the test-file timestamps are identical
        latestFile = max(foundFiles, key=os.path.getmtime)
        return latestFile

