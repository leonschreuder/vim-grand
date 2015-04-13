
require "minitest/autorun"
require_relative "../utils/test_tools"

require_relative "path_file_manager"

class PathFileManagerTest < Minitest::Test

	def setup()
		@testTools = TestTools.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_removeDuplicatePathEntries()
		result = PathFileManager.removeDuplicatePathEntries(["path/a", "path/b", "path/c", "path/d"], ["- path/b", "+ path/c"])

		assert_equal 2, result.size
		assert_equal "path/a", result[0]
		assert_equal "path/d", result[1]
	end

	def test_appendPathsToSources_shouldWriteNew()
		paths = ["path/a", "path/b", "path/c"]

		PathFileManager.appendPathsToSources(paths)

		assert File.exists?(ProjectControler::LIBRARY_PATHS_FILE)
		expected = [
			"+ path/a\n",
			"+ path/b\n",
			"+ path/c\n",
		]
		assert_equal expected, IO.readlines(".gradle_sources")
		File.delete(ProjectControler::LIBRARY_PATHS_FILE)
	end

	def test_appendPathsToSources_shouldNotRewriteDuplicats()
		@testTools.createTestFileWithContent(ProjectControler::LIBRARY_PATHS_FILE, "+ path/a\n- path/b")
		paths = ["path/a", "path/b", "path/c"]

		PathFileManager.appendPathsToSources(paths)

		expected = [
			"+ path/a\n",
			"- path/b\n",
			"+ path/c\n",
		]
		assert_equal expected, IO.readlines(ProjectControler::LIBRARY_PATHS_FILE)
	end


	def test_getPathsFromSourcesFileWithPreceiding
		@testTools.buildTestSourcesFile()

		resultPlus      = PathFileManager.getPathsFromSourcesFileWithPreceidingChar('+');
		resultMinus     = PathFileManager.getPathsFromSourcesFileWithPreceidingChar('-');
		resultSyntastic = PathFileManager.getPathsFromSourcesFileWithPreceidingChar('s');

		assert_equal(1, resultPlus.size)
		assert_equal(1, resultMinus.size)
		assert_equal(1, resultSyntastic.size)
		assert_equal('/path/plus', resultPlus[0])
		assert_equal('/path/minus', resultMinus[0])
		assert_equal('/path/syntastic', resultSyntastic[0])
	end

end
