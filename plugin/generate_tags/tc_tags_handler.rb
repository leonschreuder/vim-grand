
require_relative "tags_handler"
require "test/unit"

# Mock
module Kernel
	def self.spawn(*arg)
		@@spawned = arg
		return 0
	end

	def self.getSpawned()
		return @@spawned
	end
end

class TestTagsHandler < Test::Unit::TestCase

	def setup()
		@testTools = TestTools.new()
		@tagsHandler = TagsHandler.new()

		@android_home_value = "stub/android/home"
		ENV['ANDROID_HOME'] = @android_home_value
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_generateTagsFile_shouldCallShell()
		@testTools.createTestBuildFile()

		assert Kernel.getSpawned.size > 2, "Kernel shell should have been called"
	end

	def test_isAlreadyRunning_shouldReturnFalseWhenIsNotRunning()
		resultNotRunning = @tagsHandler.isAlreadyRunning()

		@testTools.createTestFile(".tempTags")
		resultRunning = @tagsHandler.isAlreadyRunning()

		assert(resultRunning, "Should be running")
		assert(resultNotRunning == false, "Should not be running")
	end

	def test_getCtagsCommand_shouldGenerateCommandArray()
		@testTools.createTestBuildFile()

		result = @tagsHandler.getCtagsCommand()

		expectedCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        expectedCommand += ['-f', '.tempTags']
		expectedCommand += PathResolver.new.getAllSourcePaths()

		assert_equal(expectedCommand, result, "Should have generated the right command")
	end

	def test_executeCommandAsyncly_shouldCallKernelWithArray()
		command = ['a', 'b', 'c']

		@tagsHandler.executeCommandAsyncly(command)

		assert_equal command, Kernel.getSpawned, "Should have called command on Kernel"

	end

	def test_replaceTagsWithTempTags_shouldReplaceFile()
		@testTools.createTestFile(".tags")
		@testTools.createTestFile(".tempTags")

		@tagsHandler.replaceTagsWithTempTags()

		assert File.exists?(".tempTags") == false, ".tempTags should have been removed"
		assert File.exists?(".tags") == true, ".tags should have been replaced with .tempTags"
	end


end
