
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "project_controler"

class TestProjectControler < Minitest::Test

    def setup()
        @testTools = TestTools.new()
    end

    def teardown()
        @testTools.removeTestFilesAndDirs()
    end

    def test_isGradleProject()
        preResult = ProjectControler.isGradleProject()
        @testTools.createTestBuildFile()
        postResult = ProjectControler.isGradleProject()

        refute preResult, "Should returned false if no gradle file"
        assert postResult, "Should returned true if gradle file exists"
    end

    def test_isAndroidProject()
        preResult = ProjectControler.isAndroidProject()
        @testTools.createTestFile("./src/main/AndroidManifest.xml")
        postResult = ProjectControler.isAndroidProject()

        refute preResult, "Should returned false if no Android manifest"
        assert postResult, "Should returned true if Android manifest exists"
    end
end
