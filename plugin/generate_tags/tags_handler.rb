
class TagsHandler


	# Desk-checked, not unit-tested
	def generateTagsFile()

		if !isAlreadyRunning()
			runCtagsCommand()
			replaceTagsWithTempTags()
		end
	end

	def isAlreadyRunning()
		return File.exists?(".tempTags")
	end

	def runCtagsCommand()
		command = getCtagsCommand()
		executeCommandAsyncly(command)
	end

	def getCtagsCommand()
		@finalCommandArray = []

		addBasicTagsCommand()
		addTagsTargetFile()
		addTagsReadSources()

		return @finalCommandArray
	end

	def addBasicTagsCommand()
		ctagsShellCommand = ['ctags', '--recurse', '--fields=+l', '--langdef=XML', '--langmap=Java:.java,XML:.xml', '--languages=Java,XML', '--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
		@finalCommandArray += ctagsShellCommand
	end

	def addTagsTargetFile()
		ctagsTargetFile = '.tempTags'
		@finalCommandArray += ['-f', ctagsTargetFile]
	end

	def addTagsReadSources()
		@finalCommandArray += PathResolver.new.getAllSourcePaths()
	end

	def executeCommandAsyncly(command)
		pid = Kernel.spawn(*command)
		Process.detach(pid)
	end

	def replaceTagsWithTempTags()
		File.delete(".tags")
		File.rename(".tempTags", ".tags")
	end

end
