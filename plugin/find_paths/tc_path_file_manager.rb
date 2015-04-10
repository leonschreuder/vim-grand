
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

	def test_convertOutputResultToSources()
		@testTools.createTestFileWithContent(ProjectControler::GRADLE_WRITE_FILE, "path/a:path/b:path/c")

		PathFileManager.convertOutputResultToSources()

		refute File.exists?(ProjectControler::GRADLE_WRITE_FILE)
		assert File.exists?(ProjectControler::LIBRARY_PATHS_FILE)
		expected = [
			"+ path/a\n",
			"+ path/b\n",
			"+ path/c\n",
		]
		assert_equal expected, IO.readlines(".gradle_sources")
		File.delete(ProjectControler::LIBRARY_PATHS_FILE)
	end

	def test_convertOutputResultToSources_shouldNotReplace()
		@testTools.createTestFileWithContent(ProjectControler::GRADLE_WRITE_FILE, "path/a:path/b:path/c")
		@testTools.createTestFileWithContent(ProjectControler::LIBRARY_PATHS_FILE, "+ path/a\n- path/b")

		PathFileManager.convertOutputResultToSources()

		refute File.exists?(ProjectControler::GRADLE_WRITE_FILE)
		assert File.exists?(ProjectControler::LIBRARY_PATHS_FILE)
		expected = [
			"+ path/a\n",
			"- path/b\n",
			"+ path/c\n",
		]
		assert_equal expected, IO.readlines(ProjectControler::LIBRARY_PATHS_FILE)
	end


end
