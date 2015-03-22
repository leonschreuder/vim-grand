require_relative "talk_to_gradle/gradle"
require_relative "generate_tags/tags_handler"

class Grand

	#public
	def addAllCommands()
		setupCommand("Tags")
		setupCommand("Install")
	end

	#public
	def executeCommand(command)
		methodCall = "execute"+command
		if respond_to? methodCall
			send(methodCall)
		else
			puts "Command '" + command + "' not recognised."
		end
	end

	#private
	def setupCommand(commandId)
		commandName = "Grand" + commandId
		rubyCall = "Grand.new.executeCommand('" + commandId + "')"

		command = ["command!", commandName, ":ruby", rubyCall]

		VIM.command(command.join(" "))
	end


	# Commands
	#----------------------------------------

	#protected
	def executeInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end

	#protected
	def executeTags()
		TagsHandler.new.generateTagsFile()
	end
end
