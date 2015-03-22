require_relative "talk_to_gradle/gradle"
require_relative "generate_tags/tags_handler"

class Grand

	def addAllCommands()
		setupCommand("Tags")
		setupCommand("Install")
	end

	def executeCommand(command)
		methodCall = "execute"+command
		if respond_to? methodCall
			send(methodCall)
		else
			puts "Command '" + command + "' not recognised."
		end
	end

	def setupCommand(commandId)
		commandName = "Grand" + commandId
		rubyCall = "Grand.new.executeCommand('" + commandId + "')"

		command = ["command!", commandName, ":ruby", rubyCall]

		VIM.command(command.join(" "))
	end

	# Commands
	def executeInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end

	def executeTags()
		TagsHandler.new.generateTagsFile()
	end
end
