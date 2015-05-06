require "minitest/autorun"

require_relative "gradle"
require_relative "../utils/test_tools.rb"


class StubVimProxy < VimProxy
    attr_accessor :runOnShellForResultArg
    attr_accessor :commandArg

    def initialize()
        @runOnShellForResultArg = nil
    end

    def runOnShellForResult(command)
        @runOnShellForResultArg = command
    end

    def command(command)
        @commandArg = command
    end
end

class TestGradle < Minitest::Test

	def setup()
        @vimProxy = StubVimProxy.new
		@testTools = TestTools.new
		@gradle = Gradle.new(@vimProxy)
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

    def test_setsUpCompiler()
        assert_equal "compiler gradle", @vimProxy.commandArg
    end

	def test_executeGradleCommand_shouldDefaultToStandardGradle()

		@gradle.executeGradleCommandForResult("test")

        assert_equal "test", @vimProxy.runOnShellForResultArg
	end

	# def test_executeGradleCommand_shouldUseWrapperWhenAvailable()
	# 	createGradlew()

	# 	@gradle.executeGradleCommandForResult("test")

        # assert_equal "./gradlew test", @vimProxy.runOnShellForResultArg
	# end

	def test_hasGradleWrapper_falseWhenNoWrapper()

		result = @gradle.hasGradleWrapper()

		assert !result, "Nonexisting wrapper should return false"
	end

	def test_hasGradleWrapper_shouldWorkOnUnix()
		createGradlew()

		result = @gradle.hasGradleWrapper()

		assert result, "Existing windows wrapper should return true"
	end

	def test_hasGradleWrapper_shouldWorkOnWindows()
		@testTools.createTestFile("gradlew.bat")
		FileUtils.chmod('+x', 'gradlew.bat')

		result = @gradle.hasGradleWrapper()

		assert(result, "Existing windows wrapper should return true")
	end

	def createGradlew()
		@testTools.createTestFile("gradlew")
		FileUtils.chmod('+x', 'gradlew')
	end

end
