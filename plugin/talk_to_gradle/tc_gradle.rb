require "minitest/autorun"

require_relative "gradle"
require_relative "../utils/test_tools.rb"
require_relative "../mock_vim"

class TestGradle < Minitest::Test

	def setup()
		VIM.reinit()
		VIM.setEvaluateResult false
		@testTools = TestTools.new
		@gradle = Gradle.new
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_executeGradleCommand_shouldDefaultToStandardGradle()

		@gradle.executeGradleCommand("test")

		assert_equal("! gradle test -q", VIM.getCommand()[0])
	end

	def test_executeGradleCommand_shouldUseDispatchWhenAvailable()
		VIM.setEvaluateResult true

		@gradle.executeGradleCommand("test")

		assert_equal("Dispatch gradle test -q", VIM.getCommand()[0])
	end

	def test_executeGradleCommand_shouldUseWrapperWhenAvailable()
		createGradlew()

		@gradle.executeGradleCommand("test")

		assert_equal("! ./gradlew test -q", VIM.getCommand()[0])
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

	def test_hasDispatchInstalled_shouldWork()

		@gradle.hasDispatch()

		assert_equal("exists(':Dispatch')", VIM.getEvaluate()[0])
	end

	def createGradlew()
		@testTools.createTestFile("gradlew")
		FileUtils.chmod('+x', 'gradlew')
	end

end
