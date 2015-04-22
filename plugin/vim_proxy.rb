class VimProxy

    def commandDefined?(commandName)
        if VIM.evaluate("exists(':#{commandName}')") > 0
            return true
        else
            return false
        end
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        VIM.command("command " + commandName + " :ruby " + rubyMethod + "()")
    end

end
