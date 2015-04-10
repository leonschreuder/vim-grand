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
