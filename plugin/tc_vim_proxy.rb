require 'minitest/autorun'

require_relative 'vim_proxy'
require_relative 'mock_vim'

class VimProxyTest < Minitest::Test

    def setup
        VIM.reinit()
        @proxy = VimProxy.new
    end

    def test_exists
        VIM.setEvaluateResult(1) #TODO: Remove this requirement

        result = @proxy.exists?("something")

        assert result, "Should be true"
        assert_equal "exists('something')", VIM.getEvaluate()[0]
    end

    def test_commandDefined?
        VIM.setEvaluateResult(0);

        result = @proxy.commandDefined?("GrandSetup")

        refute result, "Should be false"
        assert_equal "exists(':GrandSetup')", VIM.getEvaluate()[0]
    end

    def test_addCommandCallingRuby

        @proxy.addCommandCallingRuby("CommandName", "rubyMethod")

        assert_equal "command CommandName :ruby rubyMethod()", VIM.getCommand[0]
    end

    def test_addTagsFile

        @proxy.addTagsFile(".tags")

        assert_equal "silent! set tags+=.tags", VIM.getCommand[0]
    end

    def test_runOnShellForResult()
        VIM.setEvaluateResult(0) #TODO: Remove this requirement

        @proxy.runOnShellForResult("ls")

        assert_equal "! ls", VIM.getCommand[0]
    end

    def test_runOnShellForResult_usesDispatchIfAvailable()
        VIM.setEvaluateResult(1) #TODO: Remove this requirement

        @proxy.runOnShellForResult("ls")

        assert_equal "Dispatch ls", VIM.getCommand[0]
    end


end
