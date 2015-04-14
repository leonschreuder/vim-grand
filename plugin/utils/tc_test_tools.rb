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
		workingDirFile = 'test_createTestFile'
		subdirFile  = "someDir/test_createTestFile"
		subdir  = "someDir/testcreateTestFile/"

		@testTools.createTestFile(workingDirFile)
		@testTools.createTestFile(subdirFile)
		@testTools.createTestFile(subdir)

		assert File.exists?(workingDirFile)
		assert File.exists?(subdirFile)
		assert File.exists?(subdir)
	end

	def test_splitFile()
		fileOnly = "test_createTestFile"
		dir = "someDir/"
		subdirFile  = "someDir/test_createTestFile"
		subdir  = "someDir/test_createTestFile/"

		
		resultFileOnly  = @testTools.splitFile(fileOnly  )
		resultDir       = @testTools.splitFile(dir       )
		resultSubdirFile= @testTools.splitFile(subdirFile)
		resultSubdir    = @testTools.splitFile(subdir    )

		assert_equal [".", fileOnly], resultFileOnly
		assert_equal ["./someDir", ""], resultDir
		assert_equal ["./someDir", "test_createTestFile"], resultSubdirFile
		assert_equal ["./someDir/test_createTestFile", ""], resultSubdir
	end

	def test_createTestFileWithContent()
		file = 'test_createTestFileWithContent'
		subdirFile  = "someDir/test_createTestFile.txt"
		expected = [
			"line1\n", 
			"line2 ",
		]

		@testTools.createTestFileWithContent(file, "line1\nline2 ")
		@testTools.createTestFileWithContent(subdirFile, "line1\nline2 ")

		assert File.exists?(file)
		assert File.exists?(subdirFile)
		assert_equal expected, IO.readlines(file)
	end

	def test_createTestFileInPast()
		testFileName = 'test_createTestFile'

		@testTools.createTestFileInPast(testFileName, 10)

		assert File.exists?(testFileName), "File should have been created"
		assert_equal (Time.now - 10).to_i, File.mtime(testFileName).to_i, "File should have specified timestamp"
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
