require "minitest/autorun"

require_relative "grand"
require_relative "mock_vim"
require_relative "mock_kernel"
require_relative "utils/test_tools"

require_relative 'tc_project_controler'

class TestGrand < Minitest::Test
    ANDROID_HOME_VALUE = "stub/android/home"

    def setup()
        VIM.reinit()
        Kernel.reinit()
        ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
        @testTools = TestTools.new()
        VIM.setEvaluateResult(false)
        @grand = Grand.new()

    end

    def teardown()
        @testTools.removeTestFilesAndDirs()
        @testTools.deleteFileIfExists(ProjectControler::PATH_FILE)
    end


    def test_init_shouldAddSetupCommand()

        assert_equal "!exists(':GrandTags')", VIM.getEvaluate()[0]
        assert_equal "command GrandSetup :ruby Grand.new.executeCommand('Setup')", VIM.getCommand()[0]
    end



    def test_addAllCommands()
        VIM.setEvaluateResult(false)
        VIM.setEvaluateResult(false)

        @grand.addAllCommands()

        # TODO: Use exit check in defining mappings.
        #'if !exists(":Correct")
            #command -nargs=1  Correct  :call s:Add(<q-args>, 0)
        #endif'

        assert_equal "command GrandTags :ruby Grand.new.executeCommand('Tags')", VIM.getCommand[-2]
        assert_equal "command GrandInstall :ruby Grand.new.executeCommand('Install')", VIM.getCommand[-1]
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
