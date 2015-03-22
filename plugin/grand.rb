require_relative "talk_to_gradle/gradle"

class Grand

	def addAllCommands()
		setupCommand("Tags")
		setupCommand("Install")
	end

	def executeCommand(command)
		completeCommand = "execute"+command
		if respond_to? completeCommand
			send(completeCommand)
		else
			puts "command '" + command + "' not defined"
		end
	end

	def setupCommand(commandId)
		commandName = "Grand" + commandId
		rubyCall = "Grand.new.executeCommand('" + commandId + "')"

		command = ["command!", commandName, ":ruby", rubyCall]

		VIM.command(command.join(" "))
	end

	def executeInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end
end
