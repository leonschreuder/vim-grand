#! /usr/bin/env python

class ClassPath:
    def getClassPaths(self):
        projectClassPath = './src/main/java'
        generatedSources =  './build/intermediates/classes/debug'
        return ':'.join([projectClassPath, generatedSources])

