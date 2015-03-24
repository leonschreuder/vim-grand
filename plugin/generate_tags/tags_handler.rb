
class TagsHandler

	#public
	def generateTagsFile()
		if !isAlreadyRunning()
			runCtagsCommand()
			replaceTagsWithTempTags()
		end
	end

	#protected
	def isAlreadyRunning()
		return File.exists?(".tempTags")
	end

	#private
	def runCtagsCommand()
		command = getCtagsCommand()
		executeCommandAsyncly(command)
	end

	#protected
	def getCtagsCommand()
		@finalCommandArray = []

		addBasicTagsCommand()
		addTagsTargetFile()
		addTagsReadSources()

		return @finalCommandArray
	end

	#private
	def addBasicTagsCommand()
		ctagsShellCommand = ['ctags', '--recurse', '--fields=+l', '--langdef=XML', '--langmap=Java:.java,XML:.xml', '--languages=Java,XML', '--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
		@finalCommandArray += ctagsShellCommand
	end

	#private
	def addTagsTargetFile()
		ctagsTargetFile = '.tempTags'
		@finalCommandArray += ['-f', ctagsTargetFile]
	end

	#private
	def addTagsReadSources()
		@finalCommandArray += PathResolver.new.getAllSourcePaths()
	end

	#protected
	def executeCommandAsyncly(command)
		pid = Kernel.spawn(*command)
		Process.detach(pid)
	end

	# TODO
	# make process that calls `command`
	# start process on different thread
	# end > replace/delete .tempTags

	#protected
	def replaceTagsWithTempTags()
		File.delete(".tags") rescue nil
		File.rename(".tempTags", ".tags") rescue nil #Only happens in tests
	end

end
