require "minitest/autorun"

require_relative "../utils/test_tools"
require_relative "../mock_kernel"
require_relative "tags_handler"
require_relative "../find_paths/path_resolver"

class TestTagsHandler < Minitest::Test

	ANDROID_HOME_VALUE = "stub/android/home"

	def setup()
		Kernel.reinit()
		@testTools = TestTools.new()
		@tagsHandler = TagsHandler.new()

		ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end



	def test_generateTagsFile_shouldCallShell()
		@testTools.createTestBuildFile()

		@tagsHandler.generateTagsFile()

		assert Kernel.getSpawned() != nil
	end

	def test_isAlreadyRunning_shouldReturnFalseWhenIsNotRunning()
		resultNotRunning = @tagsHandler.isAlreadyRunning()

		@testTools.createTestFile(TagsHandler::TEMP_FILE)
		resultRunning = @tagsHandler.isAlreadyRunning()

		assert(resultRunning, "Should be running")
		assert(resultNotRunning == false, "Should not be running")
	end

	def test_getCtagsCommand_shouldGenerateCommandArray()
		@testTools.createTestBuildFile()

		result = @tagsHandler.getCtagsCommand()

		expectedCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        expectedCommand += ['-f', TagsHandler::TEMP_FILE]
		expectedCommand += PathResolver.new.getAllSourcePaths()
		expectedCommand += ['&&', 'mv', TagsHandler::TEMP_FILE, TagsHandler::TAGS_FILE]

		assert_equal(expectedCommand, result, "Should have generated the right command")
	end

	def test_executeCommandAsyncly_shouldCallKernelWithArray()
		command = ['a', 'b', 'c']
		@testTools.createTestFile(".tags")
		@testTools.createTestFile(".tempTags")

		@tagsHandler.executeShellCommand(command)

		assert_equal command.join(' '), Kernel.getSpawned()[0], "Should have called command on Kernel"
	end

end
