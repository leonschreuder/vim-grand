require 'minitest/autorun'

require_relative 'vim_proxy'
require_relative 'mock_vim'

class VimProxyTest < Minitest::Test

    def setup()
        VIM.reinit()
        @proxy = VimProxy.new
    end

    def test_exists()
        VIM.setEvaluateResult(1) #TODO: Remove this requirement

        result = @proxy.exists?("something")

        assert result, "Should be true"
        assert_equal "exists('something')", VIM.getEvaluate()[0]
    end

    def test_commandDefined?()
        VIM.setEvaluateResult(0);

        result = @proxy.commandDefined?("GrandSetup")

        refute result, "Should be false"
        assert_equal "exists(':GrandSetup')", VIM.getEvaluate()[0]
    end

    def test_addCommandCallingRuby()
        @proxy.addCommandCallingRuby("CommandName", "rubyMethod")

        assert_equal "command CommandName :ruby rubyMethod", VIM.getCommand[0]
    end

    def test_addTagsFile()
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

    def test_setGlobalVariableToValue()
        @proxy.setGlobalVariableToValue("some_global_var", 1)
        @proxy.setGlobalVariableToValue("some_global_var", "2")

        assert_equal "let g:some_global_var = 1", VIM.getCommand[0]
        assert_equal "let g:some_global_var = '2'", VIM.getCommand[1]
    end

    def test_callVimMethod()
        @proxy.callVimMethod("string")
        @proxy.callVimMethod("string", "value")

        assert_equal "silent! call string()", VIM.getCommand[0]
        assert_equal "silent! call string('value')", VIM.getCommand[1]
    end

    def test_typeToVimType()
        result = @proxy.typeToVimType(1)
        result2 = @proxy.typeToVimType("1")

        assert_equal "1", result
        assert_equal "'1'", result2
    end

end
