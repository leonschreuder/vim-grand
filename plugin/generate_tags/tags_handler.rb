

class TagsHandler

	def getCtagsCommand()
		finalCommandArray = []

		ctagsShellCommand = ['ctags', '--recurse', '--fields=+l', '--langdef=XML', '--langmap=Java:.java,XML:.xml', '--languages=Java,XML', '--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
		finalCommandArray += ctagsShellCommand

		ctagsTargetFile = '.tempTags'
		finalCommandArray += ['-f', ctagsTargetFile]

		return finalCommandArray
	end

end

    #def getCtagsCommand(self):
        #finalCommandArray = []

        ## NOTE that the \1 needed double escaping
        #ctagsShellCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        #finalCommandArray += ctagsShellCommand

        ##TODO make tag file name/location dynamic
        #ctagsTargetFile = '.tempTags'
        #finalCommandArray += ['-f', ctagsTargetFile]

        #sourcePaths = PathsResolver().getAllSourcePaths();
        #finalCommandArray += sourcePaths

        #return finalCommandArray
