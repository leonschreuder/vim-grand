require 'minitest/autorun'

require_relative 'vim_proxy'
require_relative 'mock_vim'

class VimProxyTest < Minitest::Test

    def test_commandDefined?
        proxy = VimProxy.new
        VIM.reinit()
        VIM.setEvaluateResult(0);

        result = proxy.commandDefined?("GrandSetup")

        refute result, "Should be false"
        assert_equal "exists(':GrandSetup')", VIM.getEvaluate()[0]
    end

    def test_addCommandCallingRuby
        VIM.reinit()
        proxy = VimProxy.new

        proxy.addCommandCallingRuby("CommandName", "rubyMethod")

        assert_equal "command CommandName :ruby rubyMethod()", VIM.getCommand[0]
    end

end
