#! /usr/bin/env python

import sys
import os

#from subprocess import call
import subprocess
#from subprocess import Popen
from paths_resolver import PathsResolver

class TagsHandler:
    def __init__(self):
        self.process = None
        sys.path.append(os.getcwd())

    def generateTagsFile(self):
        if (self.which('ctags') != None):
            #NOTE wouldn't a Popen(['ctags','--version']) be more to the point?
            shellIndependantCommandArray = self.getCtagsCommand()
            self.executeCommandAsyncly(shellIndependantCommandArray)
        else:
            print 'ctags executable not found. To use this command, please install it.'
        #TODO: Into help. If ctags doesn't create a file, make sure it is exurbitant-ctags
        # To check the version type 'man ctags' and at the top it should say Exurbitant Ctags (on *nix)


    def getCtagsCommand(self):
        finalCommandArray = []

        # NOTE that the \1 needed double escaping
        ctagsShellCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        finalCommandArray += ctagsShellCommand

        ctagsTargetFile = '.tags' #TODO make tag file name/location dynamic
        finalCommandArray += ['-f', ctagsTargetFile]

        sourcePaths = PathsResolver().getAllSourcePaths();
        finalCommandArray += sourcePaths

        #print " ".join(finalCommandArray)
        return finalCommandArray


    def executeCommandAsyncly(self, commandArray):
        print " ".join(commandArray)
        # FIXME: Add check to see if one is already running. Simultanius calls corrupt tags file.
        if (self.process != None and self.process.poll() != None):
            self.process = subprocess.Popen(commandArray)


    def which(self, program):
        # method copied from http://stackoverflow.com/a/377028
        import os
        def is_exe(fpath):
            return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

        fpath, fname = os.path.split(program)
        if fpath:
            if is_exe(program):
                return program
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                path = path.strip('"')
                exe_file = os.path.join(path, program)
                if is_exe(exe_file):
                    return exe_file

        return None


