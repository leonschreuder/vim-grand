class VimProxy

    def exists?(aVimObject)
        VIM.evaluate("exists('#{aVimObject}')") > 0
    end

    # convenience method
    def commandDefined?(commandName)
        return exists?(":"+commandName)
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        VIM.command("command " + commandName + " :ruby " + rubyMethod + "()")
    end

    def addTagsFile(tagsFile)
        # Note: does not accumulate
        VIM.command("silent! set tags+=" + tagsFile)
    end

    def runOnShellForResult(command)
        if exists?("Dispatch")
            VIM.command("Dispatch " + command)
        else
            VIM.command("! " + command)
        end
    end
end
