
require_relative '../vim_proxy'

class Gradle

    def initialize(vimProxy = VimProxy.new)
        @vimProxy = vimProxy
    end

	def executeGradleCommand(command)
        @@commandLastExecuted = command
		commandString = []

		commandString << getGradleExe()
		commandString << command
		commandString << "-q"

        @vimProxy.runOnShellForResult(commandString.join(" "))
	end

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
