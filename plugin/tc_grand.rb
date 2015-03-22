require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"
require_relative "mock_kernel"

class TestGrand < Minitest::Test
	def setup()
		VIM.reinit()
		Kernel.reinit()
		@testTools = TestTools.new()
		@grand = Grand.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end



	def test_addAllCommands_shouldAddCommands()
		@grand.addAllCommands()

		assert_equal "command! GrandTags :ruby Grand.new.executeCommand('Tags')", VIM.getCommand[0]
		assert_equal "command! GrandInstall :ruby Grand.new.executeCommand('Install')", VIM.getCommand[1]
	end

	def test_executeCommand_shouldCatchNonExistent()

		out = capture_io do
			@grand.executeCommand("something")
		end

		assert_equal "Command 'something' not recognised.\n", out[0]
	end

	def test_executeCommand_withInstall()
		@grand.executeCommand("Install")

		assert_equal("! gradle installDebug -q", VIM.getCommand()[0])
	end

	def test_executeCommand_withTags()
		@testTools.createTestBuildFile()

		@grand.executeCommand("Tags")

		assert Kernel.getSpawned.size > 2, "Kernel shell should have been called"
	end

end
