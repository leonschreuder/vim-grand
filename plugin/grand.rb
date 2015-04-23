require_relative 'talk_to_gradle/gradle'
require_relative 'generate_tags/tags_handler'
require_relative 'project_controler'
require_relative 'configurator'
require_relative 'find_paths/path_file_manager'
require_relative 'vim_proxy'

class Grand

	def initialize(proxy = VimProxy.new)
        @vimProxy = proxy
		setupCommand('Setup')
	end

	def addAllCommands()
        setupCommand('Tags')
		setupCommand('Install')
	end

	def executeCommand(command)
		actualMethod = 'execute'+command

		if respond_to? actualMethod
			send(actualMethod)
		else
			puts "Command \"" + command + "\" not recognised."
		end
	end

	def setupCommand(commandId)
		commandName = "Grand" + commandId
		rubyCall = "Grand.new.executeCommand('" + commandId + "')"


        if not @vimProxy.commandDefined?(commandName)
            @vimProxy.addCommandCallingRuby(commandName, rubyCall)
        end
	end


	# Commands
	#----------------------------------------

	def executeInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end

	def executeTags()
        if ProjectControler.hasExuberantCtags()
            TagsHandler.new.generateTagsFile()

            @vimProxy.addTagsFile(".tags")
        else
            puts "You need to install Exuberant-Ctags for :GrandTags to work..."
        end
	end

	def executeSetup()
		#TODO: check $ANDROID_HOME is set
		if ProjectControler.isGradleProject() and ProjectControler.isAndroidProject()
			configurator = Configurator.new()
			configurator.updatePathFile()

			configurator.setupJavacomplete()
			configurator.setupSyntastic()

			addAllCommands()
		end
	end

end
