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
		projectClassPath = './src/main/java'
		projectResPath = './src/main/res'
		return [projectClassPath, projectResPath]
	end

	def getGeneratedProjectClassPaths()
		generatedDebugClasses =  './build/intermediates/classes/debug'
		return [generatedDebugClasses]
	end


	def getGradleClassPathsFromFile()
		list = []

		filename = 'gradle-sources'

		if File.file?(filename)
			f = File.open(filename, "r")
			f.each_line do |line|
				list.push(line.chomp)
			end
			f.close()
		end

		return list
	end


	def getAndroidSdkJar()
		currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()

		sdkJarPath = File.join(getAndroidHome(), 'platforms', currentPlatformDir, 'android.jar')

		return sdkJarPath
	end

	def getAndroidSdkSourcePath()
		currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()

		sdkSourcePath = File.join(getAndroidHome(), 'sources', currentPlatformDir)

		return sdkSourcePath
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

end
