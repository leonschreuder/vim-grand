#! /usr/bin/env python

import sys
import os

import subprocess
import threading

from find_paths.paths_resolver import PathsResolver
from utils.sys_helper import SysHelper


#TODO: Into help. If ctags doesn't create a file, make sure it is
# exurbitant-ctags To check the version type 'man ctags' and at the top
# it should say Exurbitant Ctags (on *nix)


class TagsHandler:
    def __init__(self):
        if (sys != None):
            sys.path.append(os.getcwd())

    def generateTagsFile(self):
        #if (SysHelper().which('ctags') != None):
        if self.hasCtags():
            shellIndependantCommandArray = self.getCtagsCommand()
            self.executeCommandAsyncly(shellIndependantCommandArray)
        else:
            print 'ctags executable not found. To use this command, please install it.'

    def hasCtags(self):
        return SysHelper().which('ctags') != None

    def getCtagsCommand(self):
        finalCommandArray = []

        # NOTE that the \1 needed double escaping
        ctagsShellCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        finalCommandArray += ctagsShellCommand

        #TODO make tag file name/location dynamic
        ctagsTargetFile = '.tempTags'
        finalCommandArray += ['-f', ctagsTargetFile]

        sourcePaths = PathsResolver().getAllSourcePaths();
        finalCommandArray += sourcePaths

        return finalCommandArray


    """
    This runs the tags file generation in a different thread.
    If it's already running, nothing happens.
    """
    def executeCommandAsyncly(self, commandArray):

        tagsGenerationThread = threading.Thread(name='tagsGenerationThread', target=self.executeCommand, args=(commandArray,))
        
        alreadyRunning = False
        for thread in threading.enumerate():
            if thread.name == 'tagsGenerationThread':
                alreadyRunning = True

        if not alreadyRunning:
            tagsGenerationThread.start();


    """
    This generates the tags file into a temp file first and when it's done, it
    overwrites the actual tags file. I will need to imporve the performance of
    the tags generation also, but for now this allows jumping to tags while it
    is generating
    """
    def executeCommand(self, commandArray):
        subprocess.call(commandArray)
        self.replaceTagsWithTempTags()


    def replaceTagsWithTempTags(self):
        try:
            os.remove('.tags')
        except OSError:
            pass
        os.rename('.tempTags', '.tags')




