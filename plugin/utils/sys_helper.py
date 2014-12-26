#! /usr/bin/env python

import os
import fnmatch

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

    def fileExistsInCwd(self, filename):
        top = os.getcwd()

        matches = 0
        for root, dirnames, files in os.walk(top):
            for file in fnmatch.filter(files, filename):
                matches = matches + 1
        if matches > 0:
            return True
        else:
            return False
