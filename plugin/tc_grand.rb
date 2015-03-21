require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"

class TestGrand < Minitest::Test
	def setup()
		VIM.reinit()
	end

	def test_addAllCommands_shouldAddCommands()
		grand = Grand.new()

		grand.addAllCommands()

		assert_equal "command! Grand :ruby Grand.new.executeCommand()", VIM.getCommand[0]
		assert_equal "command! GrandTags :ruby GrandTags.new.executeCommand()", VIM.getCommand[1]
		assert_equal "command! GrandInstall :ruby GrandInstall.new.executeCommand()", VIM.getCommand[2]
	end


	def test_setupCommand_shouldAddCommandToVim()
		grand = Grand.new()

		grand.setupCommand("GrandSimpleTest")

		assert_equal "command! GrandSimpleTest :ruby GrandSimpleTest.new.executeCommand()", VIM.getCommand[0]
	end
end
