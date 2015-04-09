class TagsHandler

	TAGS_FILE = '.tags'
	TEMP_FILE = '.tempTags'

	#public
	def generateTagsFile()
		if !isAlreadyRunning()
			runCtagsCommand()
		end
	end

	#protected
	def isAlreadyRunning()
		# TODO: Does this even function as a valid lock?
		return File.exists?(TEMP_FILE)
	end

	#private
	def runCtagsCommand()
		command = getCtagsCommand()
		executeShellCommand(command)
	end

	#protected
	def getCtagsCommand()
		@finalCommandArray = []

		addBasicTagsCommand()
		addTagsTargetFile()
		addTagsReadSources()

		addCommandSeperator()
		addMvCommand()

		return @finalCommandArray
	end

	#private
	def addBasicTagsCommand()
		@finalCommandArray += ['ctags', '--recurse', '--fields=+l', '--langdef=XML', '--langmap=Java:.java,XML:.xml', '--languages=Java,XML', '--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
	end

	#private
	def addTagsTargetFile()
		@finalCommandArray += ['-f', TEMP_FILE]
	end

	#private
	def addTagsReadSources()
		@finalCommandArray += PathResolver.new.getAllSourcePaths()
	end

	#private
	def addCommandSeperator()
		@finalCommandArray << '&&'
	end

	#private
	def addMvCommand()
		@finalCommandArray += ['mv', TEMP_FILE, TAGS_FILE]
	end

	#protected
	def executeShellCommand(command)
		tagsProcess = Kernel.spawn(command.join(' '))
		Process.detach(tagsProcess)
	end

end
