
class Gradle

	def executeGradleCommand(command)
		commandString = []

		commandString << getCommandRunner()
		commandString << getGradleExe()
		commandString << command
		commandString << '-q'

		VIM.command(commandString.join(' '))
	end

	def getCommandRunner()
		if hasDispatch
			return 'Dispatch'
		else
			return '!'
		end
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

	def hasDispatch()
		return VIM::evaluate("exists(':Dispatch')")
	end

end
