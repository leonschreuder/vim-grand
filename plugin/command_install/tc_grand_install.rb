
require "minitest/autorun"
require_relative "grand_install"

class TestGrandInstall < Minitest::Test

	def test_executeCommand_callesGradleClass()

		VIM.reinit()

		GrandInstall.new.executeCommand()

		assert_equal("! gradle installDebug -q", VIM.getCommand()[0])
	end

end
