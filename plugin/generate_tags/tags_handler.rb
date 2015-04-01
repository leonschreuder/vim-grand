require "thread"

class TagsHandler

	#public
	def generateTagsFile()
		if !isAlreadyRunning()
			runCtagsCommand()
		end
	end

	#protected
	def isAlreadyRunning()
		return File.exists?(".tempTags")
	end

	#private
	def runCtagsCommand()
		command = getCtagsCommand()
		tagsProcess = fork {
			executeShellCommand(command)
			replaceTagsWithTempTags()
		}
		Process.detach(tagsProcess)
	end
	#Not working: Thread.new, IO.popen, Open3.popen3 --- they don't stay around after exit
	# Ask stackexchange for windows solution.

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
	def executeShellCommand(command)
		Kernel.system(*command)
	end

	#protected
	def replaceTagsWithTempTags()
		File.delete(".tags") rescue nil
		File.rename(".tempTags", ".tags") rescue nil #Only happens in tests
	end

end
