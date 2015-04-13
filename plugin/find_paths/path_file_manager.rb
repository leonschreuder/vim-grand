

class PathFileManager

	def self.convertOutputResultToSources()
		if File.exists?(ProjectControler::GRADLE_WRITE_FILE)
			pathsString = IO.readlines(ProjectControler::GRADLE_WRITE_FILE)[0]
			paths = pathsString.split(':')

			appendPathsToSources(paths)

			File.delete(ProjectControler::GRADLE_WRITE_FILE)
		end
	end

	def self.appendPathsToSources(paths)
		appending = false
		if File.exists?(ProjectControler::LIBRARY_PATHS_FILE)
			appending = true
			definedPaths = IO.readlines(ProjectControler::LIBRARY_PATHS_FILE)

			removeDuplicatePathEntries(paths, definedPaths)
		end

		reformatRawPaths(paths)

		File.open(ProjectControler::LIBRARY_PATHS_FILE, 'a') { |file|
			if appending
				file.write("\n") # Start on a new line
			end
			file.write(paths.join)
		}
	end

	def self.reformatRawPaths(paths)
		paths.each { |path|
			path.prepend "+ "
			path.concat "\n"
		}
	end

	def self.removeDuplicatePathEntries(source, duplicates)
		final = source

		duplicates.each { |duplicate|
			final.reject! do |path|
				duplicate =~ /.*#{escape_characters_in_string(path)}/
			end
		}

		return final
	end

	# Thanks http://stackoverflow.com/a/21397142/3968618
	def self.escape_characters_in_string(string)
		pattern = /(\'|\"|\.|\*|\/|\-|\\|\)|\$|\+|\(|\^|\?|\!|\~|\`)/
		string.gsub(pattern){|match|"\\"  + match}
	end

end
