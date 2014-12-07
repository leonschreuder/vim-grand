#! /usr/bin/env python

import sys
import os
import time


#from subprocess import call
import subprocess
import threading
#from subprocess import Popen
from find_paths.paths_resolver import PathsResolver

class TagsHandler:
    def __init__(self):
        if (sys != None):
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

        #ctagsTargetFile = '.tags' #TODO make tag file name/location dynamic
        ctagsTargetFile = '.tempTags' # using temp file when updating
        finalCommandArray += ['-f', ctagsTargetFile]

        sourcePaths = PathsResolver().getAllSourcePaths();
        finalCommandArray += sourcePaths

        return finalCommandArray


    def executeCommand(self, commandArray):
        # This generates the tags file into a temp file first and when it's
        # done, it overwrites the actual tags file. I will need to imporve the
        # performance of the tags generation also, but for now this allows
        # jumping to tags while it is generating
        subprocess.call(commandArray)
        try:
            os.remove('.tags')
        except OSError:
            pass
        os.rename('.tempTags', '.tags')


    def executeCommandAsyncly(self, commandArray):
        # This runs the tags file generation in a different thread.
        # If it's already running, nothing happens.


        tagsGenerationThread = threading.Thread(name='tagsGenerationThread', target=self.executeCommand, args=(commandArray,))
        
        alreadyRunning = False
        for thread in threading.enumerate():
            if thread.name == 'tagsGenerationThread':
                alreadyRunning = True

        if not alreadyRunning:
            tagsGenerationThread.start();


    #Not Used. Kept as good testing example
    def isValidTagsFile(self):
        with open('.tags', 'U') as f:
            return self.fileIsTagsFile(f)


    #Not Used. Kept as good testing example
    def fileIsTagsFile(self, file):
        lines = file.readlines()

        if (lines[0].startswith('!_TAG_FILE_FORMAT')
            and lines[1].startswith('!_TAG_FILE_SORTED')
            and lines[2].startswith('!_TAG_PROGRAM_AUTHOR')
            and lines[3].startswith('!_TAG_PROGRAM_NAME')
            and lines[4].startswith('!_TAG_PROGRAM_URL')
            and lines[5].startswith('!_TAG_PROGRAM_VERSION')):
            return True
        else:
            return False


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


