
require_relative "path_resolver"
require "test/unit"

class TestPathResolver < Test::Unit::TestCase

	def setup
		@android_home_value = "stub/android/home"
		@pathResolver = PathResolver.new()
		@testFiles = []
		@testDirs = []

		ENV['ANDROID_HOME'] = @android_home_value
	end


	def test_getAndroidHome_returnsAndroidHomeVariable

		result = @pathResolver.getAndroidHome();

		assert_equal(@android_home_value, result)
	end

	def test_getProjectSourcePaths_returnsDefaultPaths

		result = @pathResolver.getProjectSourcePaths();

        assert_equal('./src/main/java', result[0])
        assert_equal('./src/main/res', result[1])
	end

	def test_getGeneratedProjectClassPaths_returnsPathsFromFile

		result = @pathResolver.getGeneratedProjectClassPaths();

		assert_equal('./build/intermediates/classes/debug', result[0])
	end


	def test_getGradleClassPathsFromFile_shouldLoadAllLines
		buildTestSourcesFile()

		result = @pathResolver.getGradleClassPathsFromFile();

		assert_equal(2, result.size)
        assert_equal('/path/a', result[0])
        assert_equal('/path/b', result[1])

		removeTestFilesAndDirs()
	end

	def test_getAndroidVersionFromBuildGradle_shouldReturnVersionNumber
		createTestBuildFile()

		result = @pathResolver.getAndroidVersionFromBuildGradle()

		assert_equal('19', result)

		removeTestFilesAndDirs()
	end

	def test_getAndroidSdkJar_shouldGeneratePathToJar()
		createTestBuildFile()

		result = @pathResolver.getAndroidSdkJar()

		assert_equal(result, @android_home_value+"/platforms/android-19/android.jar")
		removeTestFilesAndDirs()
	end


	def test_getAndroidSdkSourcePath_shouldGenerateCorrectPath()
		createTestBuildFile()

		result = @pathResolver.getAndroidSdkSourcePath()

		assert_equal(@android_home_value + "/sources/android-19", result)

		removeTestFilesAndDirs()
	end

	def test_getExplodedAarClasses()
		mkTestDirs('./build/intermediates/exploded-arr/some_project/')
		testFile1 = './build/intermediates/exploded-arr/fakeJar.jar'
		testFile2 = './build/intermediates/exploded-arr/some_project/fakeJar2.jar'
		createTestFile(testFile1)
		createTestFile(testFile2)

		result = @pathResolver.getExplodedAarClasses()

		assert_equal(testFile1, result[0])
		assert_equal(testFile2, result[1])
		removeTestFilesAndDirs()
	end

	def test_getLatestApkFile_shouldCooseLatest()
		mkTestDirs('./build/apk/')
		createTestFileInPast( './build/apk/someNew.apk', 30)
		createTestFileInPast( './build/apk/someOld.apk', 60)

		result = @pathResolver.getLatestApkFile()

        assert_equal('./build/apk/someNew.apk', result)

		removeTestFilesAndDirs()
	end


	# Helpers
	#------------------------------------------------------------
	def buildTestSourcesFile
		@testFiles.push('gradle-sources')
		File.open("gradle-sources", 'w') {|f|
			f.write("/path/a\n/path/b")
		}
	end

	def createTestFileInPast(path, timeInPast)
		@testFiles.push(path)
		FileUtils.touch path, :mtime => Time.now - timeInPast
	end

	def createTestFile(path)
		@testFiles.push(path)
		FileUtils.touch path
	end

	def mkTestDirs(path)
		@testDirs.push(path)
		FileUtils.mkdir_p(path)
	end

	def removeTestFilesAndDirs()
		removeTestFiles()
		removeTestDirs()
	end

	def removeTestFiles()
		@testFiles.each do |file|
			File.delete(file)
		end
	end

	def removeTestDirs()
		# This removes all created (sub)dirs (now empty) in the specified path
		@testDirs.each do |testDir|
			folderArray = testDir.split(File::SEPARATOR)

			indexes = (0 .. folderArray.length-1)
			indexes.reverse_each do |i|
				currentDir = File.join(folderArray[0,i+1])

				rmdirWhenEmpty(currentDir)
			end
		end
	end

	def rmdirWhenEmpty(dir)
		begin
			Dir.rmdir(currentDir)
		rescue
			# Dir non empty. Just ignore.
		end
	end

	def createTestBuildFile()
		@testFiles.push('build.gradle')
		File.open("build.gradle", "w") { |f|
			f.write("    }\n" \
					"    compileSdkVersion 19\n" \
					"    buildToolsVersion \"19.1.0\"\n" \
					"\n" \
					"    defaultConfig {\n"
			)
		}
	end


end
