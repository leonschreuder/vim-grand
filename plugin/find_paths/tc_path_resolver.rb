
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


	#def test_getGradleClassPathsFromFile_shouldLoadAllLines
		#@testTools.buildTestSourcesFile()

		#result = @pathResolver.getGradleClassPathsFromFile();

		#assert_equal(2, result.size)
		#assert_equal('/path/a', result[0])
		#assert_equal('/path/b', result[1])

	#end

	def test_getSyntasticPathsFromSourcesFile
		@testTools.buildTestSourcesV2File()

		result = @pathResolver.getSyntasticPathsFromSourcesFile();

		assert_equal(2, result.size)
		assert_equal('/path/plus', result[0])
		assert_equal('/path/syntastic', result[1])
	end

	def test_getCompletionPathsFromSourcesFile
		@testTools.buildTestSourcesV2File()

		result = @pathResolver.getCompletionPathsFromSourcesFile();

		assert_equal(2, result.size)
		assert_equal('/path/plus', result[0])
		assert_equal('/path/completion', result[1])
	end

	def test_getPathsFromSourcesFileWithPreceiding
		@testTools.buildTestSourcesV2File()

		resultPlus = @pathResolver.getPathsFromSourcesFileWithPreceidingChar('+');
		resultMinus = @pathResolver.getPathsFromSourcesFileWithPreceidingChar('-');
		resultSyntastic = @pathResolver.getPathsFromSourcesFileWithPreceidingChar('s');

		assert_equal(1, resultPlus.size)
		assert_equal(1, resultMinus.size)
		assert_equal(1, resultSyntastic.size)
		assert_equal('/path/plus', resultPlus[0])
		assert_equal('/path/minus', resultMinus[0])
		assert_equal('/path/syntastic', resultSyntastic[0])
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
		@testTools.mkTestDirs('./build/intermediates/exploded-arr/some_project/')
		testFile1 = './build/intermediates/exploded-arr/fakeJar.jar'
		testFile2 = './build/intermediates/exploded-arr/some_project/fakeJar2.jar'
		@testTools.createTestFile(testFile1)
		@testTools.createTestFile(testFile2)

		result = @pathResolver.getExplodedAarClasses()

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
