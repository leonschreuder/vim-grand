#! /usr/bin/env python

import re
import os
import sys

class ClassPath:
    def __init__(self):
        sys.path.append(os.getcwd())


    def getAllClassPaths(self):
        paths = []
        paths.extend(self.getProjectSources())
        paths.extend(self.getProjectBuildSources())
        paths.extend(self.getPathsFromFile())
        paths.append(self.getAndroidSdkJar())
        return paths

    def getAllSourcePaths(self):
        None


    def getProjectSources(self):
        projectClassPath = './src/main/java'
        projectResPath = './src/main/res'
        #return ':'.join([projectClassPath, generatedSources])
        return [projectClassPath, projectResPath]

    def getProjectBuildSources(self):
        generatedDebugClasses =  './build/intermediates/classes/debug'
        return [generatedDebugClasses]


    def getPathsFromFile(self):
        list = []

        filename = '.syntastic-classpath'
        print os.getcwd()

        #TODO test this
        if (os.path.isfile(filename)):

            with open(filename, 'U') as f:
                for line in f:
                    list.append(line.rstrip())
        #return ':'.join(list)
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

