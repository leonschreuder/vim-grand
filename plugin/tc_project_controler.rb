
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "project_controler"
require_relative "mock_kernel"

class TestProjectControler < Minitest::Test

    CTAGS_MAN_OLD = "CTAGS(1)                  BSD General Commands Manual                 CTAGS(1)\n" 
    CTAGS_MAN_EXUBERANT = "CTAGS(1)                        Exuberant Ctags                       CTAGS(1)\n"

    def setup()
        Kernel.reinit
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

    def test_hasExuberantCtags_shouldFalseWithOldCtags()
        Kernel.backtickReturns CTAGS_MAN_OLD

        result = ProjectControler.hasExuberantCtags()

        refute result
    end

    def test_hasExuberantCtags_shouldTrueWithExuberantCtags()
        Kernel.backtickReturns CTAGS_MAN_EXUBERANT

        result = ProjectControler.hasExuberantCtags()

        assert result
    end

end
