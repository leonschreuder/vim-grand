require "find"

class PathResolver

    def getAndroidHome()
        return ENV['ANDROID_HOME']
    end

    def getStaticPaths()
        result = []
        result << './src/main/java'
        #result << './src/main/res' # TODO test influence on '.' completion
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

    def loadGradleDependencyPaths()
        if File.exists?(ProjectControler::GRADLE_WRITE_FILE)
            pathsString = IO.readlines(ProjectControler::GRADLE_WRITE_FILE)[0]
            return pathsString.split(':')
        else
            return []
        end
    end


    # TODO: Test tags completion with paths from paths_file
    # This method should be removed or moved to TagsFile
    def getAllSourcePaths()
        sourcePaths = []
        sourcePaths += getProjectSourcePaths()
        sourcePaths.push(getAndroidSdkSourcePath())
        return sourcePaths
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
        if File.exists?("build.gradle")

            currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()
            return File.join(getAndroidHome(), 'platforms', currentPlatformDir, 'android.jar')

        end
    end

    def getAndroidSdkSourcePath()
        if File.exists?("build.gradle")

            currentPlatformDir = 'android-' + getAndroidVersionFromBuildGradle()
            return File.join(getAndroidHome(), 'sources', currentPlatformDir)

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

    #public
    def getLatestApkFile()
        apks = findAllApks()
        return getMostRecentFile(apks)
    end

    def findAllApks()
        foundFiles = []
        Find.find("./build/") do |path|
            foundFiles << path if path =~ /.*\.apk$/
        end
        return foundFiles
    end

    def getMostRecentFile(filesList)
        filesList = filesList.sort_by{ |f|
            File.mtime(f)
        }.reverse

        return filesList[0]
    end


    # HELPERS
    #--------------------------------------------------------------------------------

    # Thanks http://stackoverflow.com/a/21397142/3968618
    def escape_characters_in_string(string)
        pattern = /(\'|\"|\.|\*|\/|\-|\\|\)|\$|\+|\(|\^|\?|\!|\~|\`)/
        string.gsub(pattern){|match|"\\"  + match}
    end

end
