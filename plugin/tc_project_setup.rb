
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "project_setup"


class TestProjectSetup < Minitest::Test
	def setup()
		@testTools = TestTools.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end

	def test_isGradleProject()
		@testTools.createTestBuildFile()

		result = ProjectSetup.new.isGradleProject()

		assert result, "Should returned true"
	end

	def test_isAndroidProject()
		@testTools.mkTestDirs("./src/main/")
		@testTools.createTestFile("./src/main/AndroidManifest.xml")

		result = ProjectSetup.new.isAndroidProject()

		assert result, "Should returned true"
	end
end
