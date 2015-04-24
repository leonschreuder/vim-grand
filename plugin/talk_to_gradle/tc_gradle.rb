require "minitest/autorun"

require_relative "gradle"
require_relative "../utils/test_tools.rb"


class StubVimProxy < VimProxy
    attr_accessor :runOnShellForResultArg

    def initialize()
        @runOnShellForResultArg = nil
    end

    def runOnShellForResult(command)
        @runOnShellForResultArg = command
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

	def test_executeGradleCommand_shouldDefaultToStandardGradle()

		@gradle.executeGradleCommand("test")

        assert_equal "gradle test -q", @vimProxy.runOnShellForResultArg
	end

    # TODO: Move functionality to vimProxy
	def test_executeGradleCommand_shouldUseDispatchWhenAvailable()

		@gradle.executeGradleCommand("test")

        assert_equal "gradle test -q", @vimProxy.runOnShellForResultArg
	end

	def test_executeGradleCommand_shouldUseWrapperWhenAvailable()
		createGradlew()

		@gradle.executeGradleCommand("test")

        assert_equal "./gradlew test -q", @vimProxy.runOnShellForResultArg
	end

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
