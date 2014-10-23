#! /usr/bin/env python

import sys
import os

from subprocess import call
from PathsResolver import PathsResolver

class TagsHandler:
    def __init__(self):
        sys.path.append(os.getcwd())

    def executeCtagsCommand(self):
        #TODO check if ctags exists and is right type
        finalCommandArray = []

        # TODO escape \1 again?
        #ctagsShellCommand = 'ctags --recurse --fields=+l --langdef=XML --langmap=Java:.java,XML:.xml --languages=Java,XML --regex-XML=/id="([a-zA-Z0-9_]+)"/\1/d,definition/'
        ctagsShellCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        finalCommandArray += ctagsShellCommand

        ctagsTargetFile = ['-f', '.tags'] #TODO make tag file name/location dynamic
        finalCommandArray += ctagsTargetFile

        sourcePaths = PathsResolver().getAllSourcePaths();
        finalCommandArray += sourcePaths

        print " ".join(finalCommandArray)

        call(finalCommandArray)
