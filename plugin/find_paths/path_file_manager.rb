

class PathFileManager

	def self.writeOutPaths(paths)
		@paths = paths
		@appending = false

		purgePathsAlreadyInFile()
		addPathImportSyntax()
		writePathsToFile()
	end

	def self.purgePathsAlreadyInFile(paths = @paths)
		if File.exists?(ProjectControler::LIBRARY_PATHS_FILE)
			@appending = true

			linesInFile = IO.readlines(ProjectControler::LIBRARY_PATHS_FILE)
			linesInFile.each { |line|
				paths.reject! do |path|
					line =~ /.*#{escape_characters_in_string(path)}/
				end
			}
			return paths
		end
	end

	def self.addPathImportSyntax(paths = @paths)
		paths.each { |path|
			path.prepend "+ "
		}
	end

	def self.writePathsToFile(paths = @paths)
		File.open(ProjectControler::LIBRARY_PATHS_FILE, 'a') { |file|
			if @appending
				file.write("\n") # Start on a new line
			end
			file.write(paths.join("\n"))
		}
	end

	def self.retrievePathsWithPreceidingChar(preceidingChar)
		list = []

		if File.file?(ProjectControler::LIBRARY_PATHS_FILE)
			f = File.open(ProjectControler::LIBRARY_PATHS_FILE, "r")
			f.each_line do |line|
				if line.start_with?(preceidingChar)

					list << getPathFromLine(preceidingChar, line)

				end
			end
			f.close()
		end

		return list
	end

	def self.getPathFromLine(preceidingChar, line)
		char = escape_characters_in_string(preceidingChar)
		return line[/#{char}\s*(.*)$/,1]
	end

	# Thanks http://stackoverflow.com/a/21397142/3968618
	def self.escape_characters_in_string(string)
		pattern = /(\'|\"|\.|\*|\/|\-|\\|\)|\$|\+|\(|\^|\?|\!|\~|\`)/
		string.gsub(pattern){|match|"\\"  + match}
	end

end
