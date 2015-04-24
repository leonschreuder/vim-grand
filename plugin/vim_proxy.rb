class VimProxy
    # TODO: Vim throws indeciphreable errors when some vim call isn't correct.
    # Add a 'verbose' option or something to make debugging easier.

    def exists?(aVimObject)
        VIM.evaluate("exists('#{aVimObject}')") > 0
    end

    # convenience method
    def commandDefined?(commandName)
        return exists?(":"+commandName)
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        VIM.command("command " + commandName + " :ruby " + rubyMethod)
    end

    def addTagsFile(tagsFile)
        # Note: does not accumulate
        VIM.command("silent! set tags+=" + tagsFile)
    end

    def runOnShellForResult(command)
        if commandDefined?("Dispatch")
            VIM.command("Dispatch " + command)
        else
            VIM.command("! " + command)
        end
    end

    def setGlobalVariableToValue(variableName, value)
        VIM.command("let g:" + variableName + " = " + typeToVimType(value))
    end

    def callVimMethod(methodName, args=nil)
        if args == nil
            VIM.command("silent! call " + methodName + "()")
        else
            VIM.command("silent! call " + methodName + "(" + typeToVimType(args) + ")")
        end
    end

    def typeToVimType(type)
        if type.is_a?(String)
            return "'" + type + "'"
        else
            return type.to_s()
        end
    end
end
