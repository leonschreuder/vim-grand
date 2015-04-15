
require "minitest/autorun"
require_relative "../utils/test_tools"

require_relative "../project_controler"
require_relative "path_file_manager"

class PathFileManagerTest < Minitest::Test

	def setup()
		@testTools = TestTools.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_writeOutPaths_shouldCreateFile()
		paths = ["path/a", "path/b", "path/c"]

		PathFileManager.writeOutPaths(paths)

		assert File.exists?(ProjectControler::PATH_FILE)
		expected = [
			"+ path/a\n",
			"+ path/b\n",
			"+ path/c",
		]
		assert_equal expected, IO.readlines(ProjectControler::PATH_FILE)
		@testTools.deleteFileIfExists(ProjectControler::PATH_FILE)
	end

	def test_writeOutPaths_shouldNotRewritePathsInFile()
		@testTools.createTestFileWithContent(ProjectControler::PATH_FILE, "+ path/a\n- path/b")
		paths = ["path/a", "path/b", "path/c"]

		PathFileManager.writeOutPaths(paths)

		expected = [
			"+ path/a\n",
			"- path/b\n",
			"+ path/c",
		]
		assert_equal expected, IO.readlines(ProjectControler::PATH_FILE)
	end

	def test_removeDefinedPathsFromList()
		pathsToAdd = ["path/a", "path/b", "path/c", "path/d"]
		@testTools.createTestFileWithContent(ProjectControler::PATH_FILE, "+ path/b\n- path/c")

		result = PathFileManager.purgePathsAlreadyInFile(pathsToAdd)

		assert_equal 2, result.size
		assert_equal "path/a", result[0]
		assert_equal "path/d", result[1]
	end


	def test_retrievePathsWithPreceidingChar
		content = [
			"+ /path/plus\n",
			"- /path/minus\n",
			"s /path/syntastic\n",
			"c /path/completion"
		]
		@testTools.createTestFileWithContent(ProjectControler::PATH_FILE, content.join)

		resultPlus      = PathFileManager.retrievePathsWithPreceidingChar('+');
		resultMinus     = PathFileManager.retrievePathsWithPreceidingChar('-');
		resultSyntastic = PathFileManager.retrievePathsWithPreceidingChar('s');

		assert_equal(1, resultPlus.size)
		assert_equal(1, resultMinus.size)
		assert_equal(1, resultSyntastic.size)
		assert_equal('/path/plus', resultPlus[0])
		assert_equal('/path/minus', resultMinus[0])
		assert_equal('/path/syntastic', resultSyntastic[0])
	end

end
