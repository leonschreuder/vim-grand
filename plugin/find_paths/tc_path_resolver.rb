
require_relative "path_resolver"
require "test/unit"

class TestPathResolver < Test::Unit::TestCase

	def setup
		@android_home_value = "stub/android/home"
		@pathResolver = PathResolver.new()

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

		File.delete("gradle-sources")
	end

	def test_getAndroidVersionFromBuildGradle_shouldReturnVersionNumber
		buildTestBuildFile()

		result = @pathResolver.getAndroidVersionFromBuildGradle()

		assert_equal('19', result)

		File.delete("build.gradle")
	end

	def test_getAndroidSdkJar()
		buildTestBuildFile()

		result = @pathResolver.getAndroidSdkJar()

		assert_equal(result, @android_home_value+"/platforms/android-19/android.jar")
	end


	def testGetAndroidSdkSourcePath()
		buildTestBuildFile()

		result = @pathResolver.getAndroidSdkSourcePath()

		assert_equal(@android_home_value+"/sources/android-19", result)
        #self.assertEqual(ANDROID_HOME + '/sources/android-19/', result)
	end


	# Helpers
	#------------------------------------------------------------
	def buildTestSourcesFile
		File.open("gradle-sources", 'w') {|f|
			f.write("/path/a\n/path/b")
		}
	end

	def buildTestBuildFile
		File.open("build.gradle", "w") { |f|
			f.write("    }\n" \
					"    compileSdkVersion 19\n" \
					"    buildToolsVersion \"19.1.0\"\n" \
					"\n" \
					"    defaultConfig {\n"
			)
		}
	end



    #def testGetAndroidSdkSourcePath(self):
        #result = PathsResolver().getAndroidSdkSourcePath()

        #self.assertEqual(ANDROID_HOME + '/sources/android-19/', result)


end
