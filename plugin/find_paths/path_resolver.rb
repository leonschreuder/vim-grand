require "find"

class PathResolver

	def getAndroidHome()
		return ENV['ANDROID_HOME']
	end

	def getStaticPaths()
		result = []
		result << './src/main/java'
		#result << './src/main/res' # test influence on '.'
		result << './build/intermediates/classes/debug'
		return result
	end

	def getDynamicPaths()
		result = []
		result << getAndroidSdkJar()
		result << getAndroidSdkSourcePath()
		result += getExplodedAarClasses()
		return result
	end

	def getAllSourcePaths()
		sourcePaths = []
		sourcePaths += getProjectSourcePaths()
		sourcePaths.push(getAndroidSdkSourcePath())
		return sourcePaths
	end

	def loadGradleDependencyPaths()
		if File.exists?(ProjectControler::GRADLE_WRITE_FILE)
			pathsString = IO.readlines(ProjectControler::GRADLE_WRITE_FILE)[0]
			return pathsString.split(':')
		else
			return []
		end
	end



	# Depricated. Use getStaticPaths()
	def getProjectSourcePaths()
		result = []
		result << './src/main/java'
		#result << './src/main/res' # seems to have biggest influence on '.'
		return result
	end

	# Depricated. Use getStaticPaths()
	def getBuildProjectClassPaths()
		generatedDebugClasses =  './build/intermediates/classes/debug'
		return [generatedDebugClasses]
	end




	def getAndroidSdkJar()
		if not File.exists?("build.gradle"); return; end
		currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()

		sdkJarPath = File.join(getAndroidHome(), 'platforms', currentPlatformDir, 'android.jar')

		return sdkJarPath
	end

	def getAndroidSdkSourcePath()
		if not File.exists?("build.gradle"); return; end
		androidVersion = getAndroidVersionFromBuildGradle()
		if androidVersion
			currentPlatformDir = 'android-' + androidVersion

			sdkSourcePath = File.join(getAndroidHome(), 'sources', currentPlatformDir)

			return sdkSourcePath
		end
	end

	def getExplodedAarClasses()
		foundJars = []

		if File.exists?(File.expand_path("./build/intermediates/exploded-aar"))
			Find.find("./build/intermediates/exploded-aar/") do |path|
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
