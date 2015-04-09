require "find"

class PathResolver

	def getAndroidHome()
		return ENV['ANDROID_HOME']
	end

	def getAllSourcePaths()
		sourcePaths = []
		sourcePaths += getProjectSourcePaths()
		sourcePaths.push(getAndroidSdkSourcePath())
		return sourcePaths
	end


	def getProjectSourcePaths()
		result = []
		result << './src/main/java'
		#result << './src/main/res' # seems to have biggest influence on '.'
		return result
	end

	def getBuildProjectClassPaths()
		generatedDebugClasses =  './build/intermediates/classes/debug'
		return [generatedDebugClasses]
	end


	def getSyntasticPathsFromSourcesFile()
		paths = []
		paths += getPathsFromSourcesFileWithPreceidingChar('+')
		paths += getPathsFromSourcesFileWithPreceidingChar('s')
		return paths
	end

	def getCompletionPathsFromSourcesFile()
		paths = []
		paths += getPathsFromSourcesFileWithPreceidingChar('+')
		paths += getPathsFromSourcesFileWithPreceidingChar('c')
		return paths
	end


	def getPathsFromSourcesFileWithPreceidingChar(preceidingChar)
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

	def getPathFromLine(preceidingChar, line)
		char = escape_characters_in_string(preceidingChar)
		return line[/#{char}\s*(.*)$/,1]
	end



	def getAndroidSdkJar()
		currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()

		sdkJarPath = File.join(getAndroidHome(), 'platforms', currentPlatformDir, 'android.jar')

		return sdkJarPath
	end

	def getAndroidSdkSourcePath()
		androidVersion = getAndroidVersionFromBuildGradle()
		if androidVersion
			currentPlatformDir = 'android-' + androidVersion

			sdkSourcePath = File.join(getAndroidHome(), 'sources', currentPlatformDir)

			return sdkSourcePath
		end
	end

	def getExplodedAarClasses()
		foundJars = []

		if File.exists?("build")
			Find.find("./build/") do |path|
				foundJars << path if path =~ /.*\.jar$/
			end
		end

		return foundJars
	end


	def getAndroidVersionFromBuildGradle()
		File.open 'build.gradle' do |file|
			file.find { |line|
				match = line.match(/compileSdkVersion\W*(\d*)/)
				if match
					return match.captures[0]
				end
			}
		end
	end

	def getLatestApkFile()
		foundFiles = []

		Find.find("./build/") do |path|
			foundFiles << path if path =~ /.*\.apk$/
		end


		foundFiles = foundFiles.sort_by{ |f|
			File.mtime(f)
		}.reverse

		return foundFiles[0]
	end

	# HELPERS
	#--------------------------------------------------------------------------------

	# Thanks http://stackoverflow.com/a/21397142/3968618
	def escape_characters_in_string(string)
		pattern = /(\'|\"|\.|\*|\/|\-|\\|\)|\$|\+|\(|\^|\?|\!|\~|\`)/
		string.gsub(pattern){|match|"\\"  + match}
	end

end
