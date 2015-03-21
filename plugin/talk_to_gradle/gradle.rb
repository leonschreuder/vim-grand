
class Gradle

	def executeGradleCommand(command)
		VIM.command(command)
	end

	def hasGradleWrapper()
		File.executable?('./gradlew') || File.executable?('./gradlew.bat') 
	end

	def hasDispatch()
		return VIM::evaluate("exists(':Dispatch')")
	end

end
