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


	def test_init_shouldAddSetupCommand()

		assert_equal "command! GrandSetup :ruby Grand.new.executeCommand('Setup')", VIM.getCommand[0]
	end


	def test_addAllCommands_shouldAddCommands()
		@grand.addAllCommands()

		assert_equal "command! GrandTags :ruby Grand.new.executeCommand('Tags')", VIM.getCommand[-2]
		assert_equal "command! GrandInstall :ruby Grand.new.executeCommand('Install')", VIM.getCommand[-1]
	end

	def test_executeCommand_shouldCatchNonExistent()

		out = capture_io do
			@grand.executeCommand("something")
		end

		assert_equal "Command 'something' not recognised.\n", out[0]
	end

	def test_executeCommand_withInstall()
		@grand.executeCommand("Install")

		assert_equal("! gradle installDebug -q", VIM.getCommand()[-1])
	end

	def test_executeCommand_withTags()
		@testTools.createTestBuildFile()

		@grand.executeCommand("Tags")

		# TODO: The tagsHandler is not not checked
		#assert Kernel.getSystem.size > 2, "Kernel shell should have been called"
		assert_equal 'silent! set tags+=.tags', VIM.getCommand()[-1]
	end

	def test_executeCommand_withSetup()
		@testTools.createTestBuildFile()
		@testTools.mkTestDirs("./src/main/")
		@testTools.createTestFile("./src/main/AndroidManifest.xml")

		preLength = VIM.getCommand().length

		@grand.executeCommand("Setup")
		assert_equal 6, VIM.getCommand().length - preLength, "Should add 2*Javacomplete + 1*Syntastic + 3*Grand-command through vim module"
	end

end
