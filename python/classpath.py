#! /usr/bin/env python

class ClassPath:
    def getStaticClassPaths(self):
        projectClassPath = './src/main/java'
        generatedSources =  './build/intermediates/classes/debug'
        return ':'.join([projectClassPath, generatedSources])

    def getPathsFromFile(self):
        list = []
        with open('example-classpath-file', 'U') as f:
            for line in f:
                list.append(line.rstrip())
        return ':'.join(list)

