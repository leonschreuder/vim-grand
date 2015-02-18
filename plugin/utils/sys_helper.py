#! /usr/bin/env python

import os
import fnmatch
import glob

'''
This logic is copied from http://stackoverflow.com/a/377028 . Only the
'is_exe' is tested. 'which' is tested but not for the special case in
window (don't realy understand what that is).
'''
class SysHelper:
    def which(self, program):
        # method copied from http://stackoverflow.com/a/377028

        fpath, fname = os.path.split(program)
        if self.is_exe(program):
            return program
        else:
            for path in os.environ["PATH"].split(os.pathsep):
                path = path.strip('"')
                exe_file = os.path.join(path, program)
                if self.is_exe(exe_file):
                    return exe_file

        return None

    def is_exe(self, fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)


    def fileExistsInCwd(self, filename, maxDepth):
        top = os.getcwd()

        matches = self.fileNamesRetrieve(top, maxDepth, filename)

        if len(matches) > 0:
            return True
        else:
            return False

    def fileNamesRetrieve(self, top, maxDepth, fnMask  ):
        someFiles = []
        for d in range( 1, maxDepth+1 ):
            maxGlob = "/".join( "*" * d )
            topGlob = os.path.join( top, maxGlob )
            allFiles = glob.glob( topGlob )
            someFiles.extend( [ f for f in allFiles if fnmatch.fnmatch( os.path.basename( f ), fnMask ) ] )
        return someFiles
