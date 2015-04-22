require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"
require_relative "mock_kernel"
require_relative "utils/test_tools"

require_relative 'tc_project_controler'
require_relative 'vim_proxy'

class StubVimProxy < VimProxy
    attr_accessor :commandDefinedCalledWith
    attr_accessor :commandDefinedResult
    attr_accessor :rubyCallingCommandsAdded

    def initialize()
        @commandDefinedCalledWith = nil
        @commandDefinedResult = false
        @rubyCallingCommandsAdded = []
    end

    def commandDefined?(commandName)
        @commandDefinedCalledWith = commandName
        return @commandDefinedResult
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        @rubyCallingCommandsAdded << [commandName, rubyMethod]
    end
end

class TestGrand < Minitest::Test
    ANDROID_HOME_VALUE = "stub/android/home"

    def setup()
        VIM.reinit()
        Kernel.reinit()
        ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
        @testTools = TestTools.new()
        @vimProxy = StubVimProxy.new
        VIM.setEvaluateResult(false)
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
        assert_equal @vimProxy.rubyCallingCommandsAdded[1][1], "Grand.new.executeCommand('Tags')"
        assert_equal "GrandInstall", @vimProxy.rubyCallingCommandsAdded[2][0]
        assert_equal @vimProxy.rubyCallingCommandsAdded[2][1], "Grand.new.executeCommand('Install')"
    end

    def test_executeCommand_shouldCatchNonExistent()
        out = capture_io do
            @grand.executeCommand("something")
        end

        assert_equal "Command \"something\" not recognised.\n", out[0]
    end

    def test_executeCommand_withInstall()
        VIM.setEvaluateResult(false)

        @grand.executeCommand("Install")

        assert_equal "! gradle installDebug -q", VIM.getCommand()[-1]
    end

    def test_executeCommand_withTags()
        @testTools.createTestBuildFile()
        Kernel.backtickReturns TestProjectControler::CTAGS_MAN_EXUBERANT

        @grand.executeCommand("Tags")

        # TODO: The tagsHandler is not not checked
        assert_equal "silent! set tags+=.tags", VIM.getCommand()[-1]
    end

    def test_executeCommand_withSetup()
        @testTools.createTestBuildFile()
        @testTools.createTestFile("./src/main/AndroidManifest.xml")
        VIM.setEvaluateResult(false, false)

        @grand.executeCommand("Setup")

        assert File.exists?(ProjectControler::PATH_FILE)

        commands = VIM.getCommand()
        assert contains(commands, "javacomplete#SetClassPath")
        assert contains(commands, "syntastic_java_javac_classpath")
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
