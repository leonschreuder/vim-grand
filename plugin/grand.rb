
class Grand

	def addAllCommands()
		setupCommand("Grand")
		setupCommand("GrandTags")
		setupCommand("GrandInstall")
	end

	def executeCommand()
        p "The 'Grand' command does nothing. It is only usefull for getting a quick overview of what commands are supported."
	end


	def setupCommand(commandName)
		commandCall = ".new.executeCommand()"

		command = ["command!", commandName]
		command += [":ruby", commandName + commandCall]

		VIM.command(command.join(" "))
	end
end
