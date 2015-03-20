require "minitest/autorun"

require_relative "grand"

# This is stub for the VIM module. As the VIM module is not defined when
# running the tests, ruby will simply use this class in its place.
class VIM
	def self.reinit()
			@commandInput = []
	end

	def self.command(someString)
		@commandInput.push(someString)
	end

	def self.getCommand()
		return @commandInput
	end
end


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
