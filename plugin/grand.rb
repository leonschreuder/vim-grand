require_relative "talk_to_gradle/gradle"
require_relative "generate_tags/tags_handler"
require_relative "project_controler"
require_relative "configurator"
require_relative "find_paths/path_file_manager"

class Grand

	def initialize()
		setupCommand("Setup")
	end

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

        if VIM.evaluate("!exists(':GrandTags')") == 1
        end

        command = ["command!", commandName, ":ruby", rubyCall]
        VIM.command(command.join(" "))
	end


	# Commands
	#----------------------------------------

	def executeInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end

	def executeTags()
        if ProjectControler.hasExuberantCtags()
            TagsHandler.new.generateTagsFile()

            #FIXME: This re-adds the tags every time.
            VIM.command('silent! set tags+=.tags')
        else
            p "You need to install Exuberant-Ctags for :GrandTags to work..."
        end
	end

	def executeSetup()
		#TODO: check $ANDROID_HOME is set
		if ProjectControler.isGradleProject() and ProjectControler.isAndroidProject
			configurator = Configurator.new()
			configurator.updatePathFile()

			configurator.setupJavacomplete()
			configurator.setupSyntastic()

			addAllCommands()
		end
	end

end
