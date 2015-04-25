require_relative 'talk_to_gradle/gradle'
require_relative 'generate_tags/tags_handler'
require_relative 'project_controler'
require_relative 'configurator'
require_relative 'find_paths/path_file_manager'
require_relative 'vim_proxy'

class Grand

    # NEXT:
    # Refactor

    def self.loadPlugin(proxy = VimProxy.new)
        @vimProxy = proxy
		setupCommand('Setup')
    end

	def self.setupCommand(commandId)
		commandName = "Grand" + commandId
		rubyCall = "Grand.executeGrand" + commandId + "()"

        if not @vimProxy.commandDefined?(commandName)
            @vimProxy.addCommandCallingRuby(commandName, rubyCall)
        end
	end

	def self.executeGrandInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end


	def self.executeGrandTags(proxy = VimProxy.new)
        @vimProxy = proxy
        if ProjectControler.hasExuberantCtags()
            TagsHandler.new.generateTagsFile()

            @vimProxy.addTagsFile(".tags")
        else
            puts "You need to install Exuberant-Ctags for :GrandTags to work..."
        end
	end

	def self.executeGrandSetup(proxy = VimProxy.new)
        @vimProxy = proxy
		#TODO: check $ANDROID_HOME is set
		if ProjectControler.isGradleProject() and ProjectControler.isAndroidProject()
			configurator = Configurator.new()
			configurator.updatePathFile()

			configurator.setupJavacomplete()
			configurator.setupSyntastic()

			addAllCommands()
		end
	end

	def self.addAllCommands(proxy = VimProxy.new)
        @vimProxy = proxy
        setupCommand('Tags')
		setupCommand('Install')
	end

end
