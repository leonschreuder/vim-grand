class TagsHandler

	TAGS_FILE = '.tags'
	TEMP_FILE = '.tempTags'

	def generateTagsFile()
		if !isAlreadyRunning()
			runCtagsCommand()
		end
	end

	def isAlreadyRunning()
		# Is this reliable enough as a lock? Tryout if it causes any problems.
		return File.exists?(TEMP_FILE)
	end

	def runCtagsCommand()
		command = constructCtagsCommand()
		executeShellCommand(command)
	end

	def constructCtagsCommand()
		@finalCommandArray = []

		addBasicTagsCommand()
		addTagsTargetFile()
		addTagsReadSources()

		addCommandSeperator()
		addMvCommand()

		return @finalCommandArray
	end

	def addBasicTagsCommand()
		@finalCommandArray += ['ctags', '--recurse', '--fields=+l', '--langdef=XML', '--langmap=Java:.java,XML:.xml', '--languages=Java,XML', '--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
	end

	def addTagsTargetFile()
		@finalCommandArray += ['-f', TEMP_FILE]
	end

	def addTagsReadSources()
		@finalCommandArray += PathResolver.new.getAllSourcePaths()
	end

	def addCommandSeperator()
		@finalCommandArray << '&&'
	end

	def addMvCommand()
		@finalCommandArray += ['mv', TEMP_FILE, TAGS_FILE]
	end


	def executeShellCommand(command)
		tagsProcess = Kernel.spawn(command.join(' '))
		Process.detach(tagsProcess)
	end

end
