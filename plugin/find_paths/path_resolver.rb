
class PathResolver

	def getAndroidHome
		return ENV['ANDROID_HOME']
	end

	def getProjectSourcePaths
        projectClassPath = './src/main/java'
        projectResPath = './src/main/res'
        return [projectClassPath, projectResPath]
	end

	def getGeneratedProjectClassPaths
        generatedDebugClasses =  './build/intermediates/classes/debug'
        return [generatedDebugClasses]
	end


	def getGradleClassPathsFromFile
		list = []

		filename = 'gradle-sources'

		f = File.open(filename, "r")
		f.each_line do |line|
			list.push(line.chomp)
		end
		f.close()

		return list
	end


	def getAndroidSdkJar

        #currentPlatformDir = 'android-' + self.getAndroidVersionFromBuildGradle()

        #sdkJarPath = androidHome +os.sep+ 'platforms' +os.sep+ currentPlatformDir +os.sep+ 'android.jar'
        #return sdkJarPath
	end


    #def getAndroidSdkJar(self):
        #androidHome = os.environ.get('ANDROID_HOME')
        #currentPlatformDir = 'android-' + self.getAndroidVersionFromBuildGradle()

        #sdkJarPath = androidHome +os.sep+ 'platforms' +os.sep+ currentPlatformDir +os.sep+ 'android.jar'
        #return sdkJarPath


	def getAndroidVersionFromBuildGradle

		File.open 'build.gradle' do |file|
			file.find { |line|
				match = line.match(/(?:compileSdkVersion\W*)(\d*)/)
				if match
					return match.captures[0]
				end
			}
		end

	end

    #def getAndroidVersionFromBuildGradle(self):
        #with open('build.gradle', 'U') as f:
            #for line in f:
                #result = self.getAndroidVersionFromLine(line)
                #if (result != None):
                    #return result

end
