class VimProxy
    # TODO: Vim throws indeciphreable errors when some vim call isn't correct.
    # Add a 'verbose' option or something to make debugging easier.

    def exists?(aVimObject)
        result = evaluate("exists('#{aVimObject}')")
        if result != nil
            return result > 0
        end
    end

    # convenience method
    def commandDefined?(commandName)
        return exists?(":"+commandName)
    end

    def addCommandCallingRuby(commandName, rubyMethod)
        command("command " + commandName + " :ruby " + rubyMethod)
    end

    def addTagsFile(tagsFile)
        # Note: does not accumulate
        command("silent! set tags+=" + tagsFile)
    end

    def runOnShellForResult(command)
        if commandDefined?("Dispatch")
            command("Dispatch " + command)
        else
            command("! " + command)
        end
    end

    def setGlobalVariableToValue(variableName, value)
        command("let g:" + variableName + " = " + typeToVimType(value))
    end

    def callVimMethod(methodName, args=nil)
        if args == nil
            command("silent! call " + methodName + "()")
        else
            command("silent! call " + methodName + "(" + typeToVimType(args) + ")")
        end
    end

    def typeToVimType(type)
        if type.is_a?(String)
            return "'" + type + "'"
        else
            return type.to_s()
        end
    end

    private
    def evaluate(command)
        begin
            return VIM.evaluate(command)
        rescue NameError
        end
    end

    private
    def command(arg)
        begin
            return VIM.command(arg)
        rescue NameError
        end
    end
end
