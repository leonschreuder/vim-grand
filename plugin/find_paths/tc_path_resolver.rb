
require "minitest/autorun"

require_relative "path_resolver"
require_relative "../utils/test_tools"

class TestPathResolver < Minitest::Test

	def setup
		@testTools = TestTools.new()
		@pathResolver = PathResolver.new()

		@android_home_value = "stub/android/home"
		ENV['ANDROID_HOME'] = @android_home_value
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_getAllSourcePaths()
		@testTools.createTestBuildFile()

		result = @pathResolver.getAllSourcePaths()

		assert_equal(1+1, result.length)
	end

	def test_getStaticPaths()
		result = @pathResolver.getStaticPaths()

		assert_equal('./src/main/java', result[0])
		assert_equal './build/intermediates/classes/debug', result[1]
	end

	def test_getDynamicPaths()
		@testTools.createTestBuildFile()
		@testTools.mkTestDirs('./build/intermediates/exploded-aar/some_project/')
		testFile1 = './build/intermediates/exploded-aar/fakeJar.jar'
		testFile2 = './build/intermediates/exploded-aar/some_project/fakeJar2.jar'
		@testTools.createTestFile(testFile1)
		@testTools.createTestFile(testFile2)

		result = @pathResolver.getDynamicPaths()

		assert_equal @android_home_value + "/platforms/android-19/android.jar", result[0]
		assert_equal @android_home_value + "/sources/android-19", result[1]
		assert_equal(testFile1, result[2])
		assert_equal(testFile2, result[3])
	end

	def test_loadGradleDependencyPaths_shoulReadPathsFromFile()
		@testTools.createTestFileWithContent(ProjectControler::GRADLE_WRITE_FILE, "path/a:path/b:path/c")

		result = @pathResolver.loadGradleDependencyPaths()

		assert_equal 3, result.length
		assert_equal [ "path/a", "path/b", "path/c", ], result
	end


	def test_getAndroidHome_returnsAndroidHomeVariable

		result = @pathResolver.getAndroidHome();

		assert_equal(@android_home_value, result)
	end

	def test_getProjectSourcePaths_returnsDefaultPaths

		result = @pathResolver.getProjectSourcePaths();

		assert_equal('./src/main/java', result[0])
		#assert_equal('./src/main/res', result[1])
	end

	def test_getGeneratedProjectClassPaths_returnsPathsFromFile

		result = @pathResolver.getBuildProjectClassPaths();

		assert_equal('./build/intermediates/classes/debug', result[0])
	end




	def test_getAndroidVersionFromBuildGradle_shouldReturnVersionNumber
		@testTools.createTestBuildFile()

		result = @pathResolver.getAndroidVersionFromBuildGradle()

		assert_equal('19', result)
	end

	def test_getAndroidSdkJar_shouldGeneratePathToJar()
		@testTools.createTestBuildFile()

		result = @pathResolver.getAndroidSdkJar()

		assert_equal(result, @android_home_value+"/platforms/android-19/android.jar")
	end


	def test_getAndroidSdkSourcePath_shouldGenerateCorrectPath()
		@testTools.createTestBuildFile()

		result = @pathResolver.getAndroidSdkSourcePath()

		assert_equal(@android_home_value + "/sources/android-19", result)
	end

	def test_getExplodedAarClasses()
		@testTools.mkTestDirs('./build/intermediates/exploded-aar/some_project/')
		@testTools.mkTestDirs('./build/intermediates/pre-dexed/some_project/')
		testFile1 = './build/intermediates/exploded-aar/fakeJar.jar'
		testFile2 = './build/intermediates/exploded-aar/some_project/fakeJar2.jar'
		testFile3 = './build/intermediates/pre-dexed/some_project/fakeJar3.jar'
		@testTools.createTestFile(testFile1)
		@testTools.createTestFile(testFile2)
		@testTools.createTestFile(testFile3)

		result = @pathResolver.getExplodedAarClasses()

		assert_equal(2, result.length)
		assert_equal(testFile1, result[0])
		assert_equal(testFile2, result[1])
	end

	def test_getLatestApkFile_shouldCooseLatest()
		@testTools.mkTestDirs('./build/apk/')
		@testTools.createTestFileInPast( './build/apk/someNew.apk', 30)
		@testTools.createTestFileInPast( './build/apk/someOld.apk', 60)

		result = @pathResolver.getLatestApkFile()

		assert_equal('./build/apk/someNew.apk', result)
	end

end
