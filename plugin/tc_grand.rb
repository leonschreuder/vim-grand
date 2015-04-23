require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"
require_relative "mock_kernel"
require_relative "utils/test_tools"

require_relative "tc_project_controler"
require_relative "vim_proxy"

class StubVimProxy < VimProxy
    attr_accessor :commandDefinedCalledWith
    attr_accessor :commandDefinedResult
    attr_accessor :rubyCallingCommandsAdded
    attr_accessor :tagsFileAdded

    def initialize()
        @commandDefinedResult = false
        @rubyCallingCommandsAdded = []
        @tagsFileAdded = nil
        #p "initialize being called"
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

    def addTagsFile(tagsFile)
        @tagsFileAdded = tagsFile
    end
end

class TestGrand < Minitest::Test
    ANDROID_HOME_VALUE = "stub/android/home"

    def setup()
        VIM.reinit()
        Kernel.reinit()
        ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
        @vimProxy = StubVimProxy.new()
        @testTools = TestTools.new()
        @grand = Grand.new(@vimProxy)
    end

    def teardown()
        @testTools.removeTestFilesAndDirs()
        @testTools.deleteFileIfExists(ProjectControler::PATH_FILE)
    end


    def test_init_shouldAddSetupCommand()

        @vimProxy.commandDefinedResult = true
        @grand.setupCommand("Setup")

        assert_equal @vimProxy.commandDefinedCalledWith, "GrandSetup"
        assert_equal @vimProxy.rubyCallingCommandsAdded[0], ["GrandSetup",  "Grand.new.executeCommand('Setup')"]
    end

    def test_addAllCommands()

        @grand.addAllCommands()

        assert_equal 3, @vimProxy.rubyCallingCommandsAdded.length
        assert_equal "GrandTags", @vimProxy.rubyCallingCommandsAdded[1][0]
        assert_equal "Grand.new.executeCommand('Tags')", @vimProxy.rubyCallingCommandsAdded[1][1]
        assert_equal "GrandInstall", @vimProxy.rubyCallingCommandsAdded[2][0]
        assert_equal "Grand.new.executeCommand('Install')", @vimProxy.rubyCallingCommandsAdded[2][1]
    end

    #TODO: Remove this madness (Needless Complexity)
    def test_executeCommand_shouldCatchNonExistent()
        out = capture_io do
            @grand.executeCommand("something")
        end

        assert_equal "Command \"something\" not recognised.\n", out[0]
    end

    def test_executeCommand_withInstall()
        VIM.setEvaluateResult(0)

        @grand.executeCommand("Install")

        assert_equal "installDebug", Gradle.getCommandLastExecuted()
    end

    def test_executeCommand_withTags()
        @testTools.createTestBuildFile()
        Kernel.backtickReturns TestProjectControler::CTAGS_MAN_EXUBERANT

        @grand.executeCommand("Tags")

        assert_equal ".tags", @vimProxy.tagsFileAdded
    end

    def test_executeCommand_withSetup()
        @testTools.createTestBuildFile()
        @testTools.createTestFile("./src/main/AndroidManifest.xml")
        VIM.setEvaluateResult(false, false) #TODO: Remove me

        @grand.executeCommand("Setup")

        assert Configurator.pathFileWasUpdated?, "Should have updated path file"
        assert File.exists?(ProjectControler::PATH_FILE)
        assert Configurator.javacompleteWasSetUp?, "Should have setup javacomplete"
        assert Configurator.syntasticWasSetUp?, "Should have setup sysntastic"
    end

    # Helpers
    #--------------------------------------------------------------------------------
    def contains(array, string)
        array.each { |command|
            return true if command =~ /#{string}/
        }
        return false
    end

end
