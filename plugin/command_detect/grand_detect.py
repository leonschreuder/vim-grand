import vim
import os
import sys
import fnmatch


class GrandDetect:

    def executeCommand(self):
        vim.command("let g:isAndroidProject = %d" % self.isAndroidGradleProject())
        #vim.command("return %d" % self.isAndroidGradleProject())

    def isAndroidGradleProject(self):
        if(self.isGradleProject() and self.isAndroidProject()):
            return 1
        else:
            return 0


    def isGradleProject(self):
        return self.findFileInDirectory("build.gradle")
    
    def isAndroidProject(self):
        return self.findFileInDirectory("AndroidManifest.xml")

    def findFileInDirectory(self, filename):
        top = os.getcwd()
        
        matches = 0
        for root, dirnames, files in os.walk(top):
            for file in fnmatch.filter(files, filename):
                matches = matches + 1
        if matches > 0:
            return True
        else:
            return False
