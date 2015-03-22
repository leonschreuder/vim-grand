require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"

class TestGrand < Minitest::Test
	def setup()
		VIM.reinit()
		@grand = Grand.new()
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

		assert_equal "command 'something' not defined\n", out[0]
	end

	def test_executeCommand_withInstall()
		@grand.executeCommand("Install")

		assert_equal("! gradle installDebug -q", VIM.getCommand()[0])
	end

end
