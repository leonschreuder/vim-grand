require "minitest/autorun"

require_relative "gradle"
require_relative "../utils/test_tools.rb"

class VIM
	#def self.reinit()
		#@command = nil
		#@evaluate = nil
	#end

	#def self.command(command)
		#@command = command
	#end

	#def self.getCommand()
		#return @command
	#end

	def self.evaluate(evl)
		@evaluate = evl
	end

	def self.getEvaluate()
		return @evaluate
	end

end

class TestGradle < Minitest::Test

	def setup()
		@testTools = TestTools.new
		@gradle = Gradle.new
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_executeGradleCommand()

		@gradle.executeGradleCommand("test")

		# TODO VIM module classes are messing eachother up because they are
		# both static I guess. Try converting to one VIM class

		#assert_equal("test", Vim.getCommand())
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

		assert_equal("exists(':Dispatch')", VIM.getEvaluate())
	end

end
