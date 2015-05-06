require_relative "../vim_proxy"

class Gradle

    def initialize(vimProxy = VimProxy.new)
        @vimProxy = vimProxy
        @vimProxy.command("compiler gradle")
    end

    def executeGradleCommandForResult(command)
        @@commandLastExecuted = command

        # The compiler handles selecting the executable. So just pass it on.
        @vimProxy.runOnShellForResult(command)
    end

    # def executeGradleCommand(command)
    #     @@commandLastExecuted = command
    #     commandString = []

    #     commandString << getGradleExe()
    #     commandString << command

    #     @vimProxy.runOnShellForResult(commandString.join(" "))
    # end

    #TODO: Add support for gradlew.bat
    def getGradleExe()
        if hasGradleWrapper
            return './gradlew'
        else
            return 'gradle'
        end
    end

    def hasGradleWrapper()
        File.executable?('./gradlew') || File.executable?('./gradlew.bat') 
    end


    def self.getCommandLastExecuted(); @@commandLastExecuted; end

end
