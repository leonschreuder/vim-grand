
require_relative "tags_handler"
require "test/unit"

class TestTagsHandler < Test::Unit::TestCase

	def setup()
		@testTools = TestTools.new()

		@android_home_value = "stub/android/home"
		ENV['ANDROID_HOME'] = @android_home_value
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_isAlreadyRunning_shouldReturnFalseWhenIsNotRunning()

		result = TagsHandler.new.isAlreadyRunning()

		assert(result == false, "Should not be running")

	end

	def test_isAlreadyRunning_shouldReturnTrueWhenRunning()
		@testTools.createTestFile(".tempTags")

		result = TagsHandler.new.isAlreadyRunning()

		assert(result, "Should be running")
	end

	def test_getCtagsCommand_shouldGenerateCommandArray()
		@testTools.createTestBuildFile()

		result = TagsHandler.new.getCtagsCommand()

		expectedCommand = ['ctags','--recurse','--fields=+l','--langdef=XML','--langmap=Java:.java,XML:.xml','--languages=Java,XML','--regex-XML=/id="([a-zA-Z0-9_]+)"/\\1/d,definition/']
        expectedCommand += ['-f', '.tempTags']
		expectedCommand += PathResolver.new.getAllSourcePaths()

		assert_equal(expectedCommand, result)
	end

	def test_replaceTagsWithTempTags_shouldReplaceFile()
		@testTools.createTestFile(".tags")
		@testTools.createTestFile(".tempTags")

		TagsHandler.new.replaceTagsWithTempTags()

		assert File.exists?(".tempTags") == false, ".tempTags should have been removed"
		assert File.exists?(".tags") == true, ".tags should have been replaced with .tempTags"
	end


end

#class TestTagsHandler (unittest.TestCase):
    #def testInstantiations(self):
        #handler = TagsHandler()
        #self.assertTrue(handler != None)

    #@patch('generate_tags.tags_handler.os')
    #@patch('generate_tags.tags_handler.subprocess')
    #def testExecuteCommand(self, mock_subprocess, mock_remove):
        #handler = TagsHandler()

        #handler.executeCommand(['some','shell', 'array'])

        #mock_subprocess.call.assert_called_with(['some','shell', 'array'])

        #mock_remove.remove.assert_called_once_with('.tags')
        #mock_remove.rename.assert_called_once_with('.tempTags', '.tags')

        

