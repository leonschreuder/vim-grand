require "minitest/autorun"

require_relative "gradle"
require_relative "../utils/test_tools.rb"
require_relative "../mock_vim"

class TestGradle < Minitest::Test

	def setup()
		VIM.reinit()
		@testTools = TestTools.new
		@gradle = Gradle.new
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_executeGradleCommand()

		@gradle.executeGradleCommand("test")

		assert_equal("test", VIM.getCommand()[0])
	end

	def test_hasGradleWrapper_falseWhenNoWrapper()

		result = @gradle.hasGradleWrapper()

		assert !result, "Nonexisting wrapper should return false"
	end

	def test_hasGradleWrapper_shouldWorkOnUnix()
		@testTools.createTestFile("gradlew")
		FileUtils.chmod('+x', 'gradlew')

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

end
