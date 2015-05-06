require "minitest/autorun"

require_relative "grand"
require_relative "mock_kernel"
require_relative "utils/test_tools"

require_relative "tc_project_controler"
require_relative "vim_proxy"
require_relative "read_test_results/tc_quickfix_content_generator"
require_relative "../filter/quick_fix_filter"

class StubVimProxy < VimProxy
    attr_accessor :commandDefinedCalledWith
    attr_accessor :commandDefinedResult
    attr_accessor :rubyCallingCommandsAdded
    attr_accessor :tagsFileAdded
    attr_accessor :stringLoadedToQuickfix
    attr_accessor :currentFileName

    def initialize()
        @commandDefinedResult = false
        @rubyCallingCommandsAdded = []
        @tagsFileAdded = nil
    end

    def commandDefined?(commandName)
        @commandDefinedCalledWith = commandName
        return @commandDefinedResult
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        if @rubyCallingCommandsAdded == nil
            @rubyCallingCommandsAdded = []
        end
        @rubyCallingCommandsAdded << [commandName, rubyMethod]
    end

    def loadStringToQuickFix(string)
        @stringLoadedToQuickfix = string
    end

    def addTagsFile(tagsFile)
        @tagsFileAdded = tagsFile
    end

    def getCurrentFileName()
        return @currentFileName
    end
end

class TestGrand < Minitest::Test
    ANDROID_HOME_VALUE = "stub/android/home"

    def setup()
        Kernel.reinit()
        ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
        @vimProxy = StubVimProxy.new()
        @testTools = TestTools.new()
    end

    def teardown()
        @testTools.removeTestFilesAndDirs()
        @testTools.deleteFileIfExists(ProjectControler::PATH_FILE)
    end


    def test_loadPlugin()
        Grand.loadPlugin(@vimProxy)

        assert_equal @vimProxy.commandDefinedCalledWith, "GrandSetup"
        assert_equal @vimProxy.rubyCallingCommandsAdded[0], ["GrandSetup",  "Grand.executeGrandSetup"]
    end

    def test_executeGrandInstall()
        Kernel.backtickReturns "List of devices attached\nR32D202RWKA\tdevice\n\n"

        Grand.executeGrandInstall()

        assert_equal "installDebug", Gradle.getCommandLastExecuted()
    end

    def test_executeGrandTags()
        @testTools.createTestBuildFile()
        Kernel.backtickReturns TestProjectControler::CTAGS_MAN_EXUBERANT

        Grand.executeGrandTags(@vimProxy)

        assert_equal ".tags", @vimProxy.tagsFileAdded
    end

    def test_executeGrandSetup()
        @testTools.createTestBuildFile()
        @testTools.createTestFile("./src/main/AndroidManifest.xml")
        @vimProxy.commandDefinedResult = false

        Grand.executeGrandSetup()

        assert Configurator.pathFileWasUpdated?, "Should have updated path file"
        assert File.exists?(ProjectControler::PATH_FILE)
        assert Configurator.javacompleteWasSetUp?, "Should have setup javacomplete"
        assert Configurator.syntasticWasSetUp?, "Should have setup sysntastic"
    end

    def test_executeGrandTest()
        scriptFile = QuickFixFilter.getScriptPath()

        Grand.executeGrandTest(nil)

        assert_equal "testDebug -i | " + scriptFile, Gradle.getCommandLastExecuted()
    end

    def test_executeGrandTest_withCurrentFile()
        scriptFile = QuickFixFilter.getScriptPath()
        @vimProxy.currentFileName = "SomeFile"

        Grand.executeGrandTest("%", @vimProxy)

        assert_equal "testDebug -i -DtestDebug.single=SomeFile | " + scriptFile, Gradle.getCommandLastExecuted()
    end

    def test_executeGrandTest_withClean()
        scriptFile = QuickFixFilter.getScriptPath()

        Grand.executeGrandTest("!")

        assert_equal "clean testDebug -i | " + scriptFile, Gradle.getCommandLastExecuted()
    end


    def test_loadTestResults()
        @testTools.copyFileForTest(QuickfixContentGeneratorTest::TEST_SOURCES_DIR + 'test_result_failing.xml', QuickfixContentGeneratorTest::TEST_RESULT_DIR)

        Grand.loadTestResults(@vimProxy)
       
        refute_nil @vimProxy.stringLoadedToQuickfix
        resultLines = @vimProxy.stringLoadedToQuickfix.split('\n')
        assert_equal 1, resultLines.length
    end

    def test_addAllCommands()

        Grand.addAllCommands(@vimProxy)

        assert_equal 3, @vimProxy.rubyCallingCommandsAdded.length

        assert_equal "GrandTags", @vimProxy.rubyCallingCommandsAdded[0][0]
        assert_equal "Grand.executeGrandTags", @vimProxy.rubyCallingCommandsAdded[0][1]

        assert_equal "GrandInstall", @vimProxy.rubyCallingCommandsAdded[1][0]
        assert_equal "Grand.executeGrandInstall", @vimProxy.rubyCallingCommandsAdded[1][1]

        assert_equal "-nargs=? -bang GrandTest", @vimProxy.rubyCallingCommandsAdded[2][0]
        assert_equal "Grand.executeGrandTest '<bang><args>'", @vimProxy.rubyCallingCommandsAdded[2][1]
    end

end
