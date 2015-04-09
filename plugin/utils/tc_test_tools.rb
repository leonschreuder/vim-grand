require "minitest/autorun"

require_relative "test_tools"

class TestTestTools < Minitest::Test

	def setup()
		@testTools = TestTools.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_makeDirs()
		dir = 'someDir'

		@testTools.mkTestDirs(dir)

		assert Dir.exists?(dir)
	end

	def test_createTestFile()
		testFileName = 'test_createTestFile'

		@testTools.createTestFile(testFileName)

		assert File.exists?(testFileName)
	end

	def test_createTestFileInPast()
		testFileName = 'test_createTestFile'

		@testTools.createTestFileInPast(testFileName, 10)

		assert File.exists?(testFileName), "File should have been created"
		assert_equal (Time.now - 10).to_i, File.mtime(testFileName).to_i, "File should have specified timestamp"
	end

	def test_createTestFileWithContent()
		file = 'test_createTestFileWithContent'
		expected = [
			"line1\n", 
			"line2 ",
		]

		@testTools.createTestFileWithContent(file, "line1\nline2 ")

		assert File.exists?(file)
		assert_equal expected, IO.readlines(file)
	end

	def test_buildTestSourcesFile()

		@testTools.buildTestSourcesFile()

		assert File.exists?(ProjectControler::LIBRARY_PATHS_FILE)

		expected = [
			"+ /path/plus\n", 
			"- /path/minus\n", 
			"s /path/syntastic\n", 
			"c /path/completion",
		]
		assert_equal expected, IO.readlines(ProjectControler::LIBRARY_PATHS_FILE)
	end

	def test_createTestBuildFile()

		@testTools.createTestBuildFile()

		assert File.exists?(ProjectControler::GRADLE_BUILD_FILE)

		expected = [
			"	 }\n",
			"	 compileSdkVersion 19\n",
			"	 buildToolsVersion \"19.1.0\"\n",
			"\n",
			"	 defaultConfig {\n",
		]
		assert_equal expected, IO.readlines(ProjectControler::GRADLE_BUILD_FILE)
	end


	def test_removeTestFilesAndDirs()
		file = 'test_removeTestFilesAndDirs'
		file2 = 'test_removeTestFilesAndDirs_withContent'
		dir = 'someDir'
		fileInDir = 'someDir/file'
		@testTools.createTestFile(file)
		@testTools.mkTestDirs(dir)
		@testTools.createTestFile(fileInDir)
		@testTools.createTestFileWithContent(file2, "line1\nline2 ")

		@testTools.removeTestFilesAndDirs()

		refute File.exists?(file)
		refute File.exists?(file2)
		refute File.exists?(fileInDir)
		refute Dir.exists?(dir)
	end

end
