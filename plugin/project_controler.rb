require 'find'

class ProjectControler

	ANDROID_MANIFEST_FILE = 'AndroidManifest.xml'
	GRADLE_BUILD_FILE = "build.gradle"
	GRADLE_WRITE_FILE = ".output_paths_result"  #Carefull, this is seperately defined in the grand.gradle
	LIBRARY_PATHS_FILE = ".gradle_sources"

	def self.isGradleProject()
		return File.exists?(GRADLE_BUILD_FILE)
	end

	def self.isAndroidProject()
		if findFileWithDepth(ANDROID_MANIFEST_FILE, 4)
			return true
		end
		return false
	end

	def self.convertOutputResultToSources()
		if not File.exists?(GRADLE_WRITE_FILE)
			return
		end

		pathsString = IO.readlines(GRADLE_WRITE_FILE)[0]
		paths = pathsString.split(':')
		appending = false

		if File.exists?(LIBRARY_PATHS_FILE)
			appending = true
			definedPaths = IO.readlines(LIBRARY_PATHS_FILE)

			removeDuplicatePathEntries(paths, definedPaths)

			definedPaths.last << "\n"
		end

		paths.each { |path|
			path.prepend "+ "
			path.concat "\n"
		}


		File.open(LIBRARY_PATHS_FILE, 'a') { |file|
			if appending
				file.write("\n")
			end
			file.write(paths.join)
		}
		File.delete(GRADLE_WRITE_FILE)
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


	# HELPERS
	#--------------------------------------------------------------------------------

	# regex filename alowed
	def self.findFileWithDepth(filename, depth)
		Find.find("./") { |f|
			if f =~ /.*\/#{filename}$/
				return f
			end
			if f.scan(%r{/}).size > depth
				Find.prune
			end
		}
		return nil
	end

	# Thanks http://stackoverflow.com/a/21397142/3968618
	def self.escape_characters_in_string(string)
		pattern = /(\'|\"|\.|\*|\/|\-|\\|\)|\$|\+|\(|\^|\?|\!|\~|\`)/
		string.gsub(pattern){|match|"\\"  + match}
	end
end
