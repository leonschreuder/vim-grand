require_relative 'talk_to_gradle/gradle'
require_relative 'generate_tags/tags_handler'
require_relative 'project_controler'
require_relative 'configurator'
require_relative 'find_paths/path_file_manager'
require_relative 'vim_proxy'
require_relative 'read_test_results/quickfix_content_generator'

class Grand

    def self.loadPlugin(proxy = VimProxy.new)
        @vimProxy = proxy
		setupCommand('GrandSetup')
    end

	def self.setupCommand(commandName)
		rubyMethodCall = "Grand.execute" + commandName + "()"

        if not @vimProxy.commandDefined?(commandName)
            @vimProxy.addCommandCallingRuby(commandName, rubyMethodCall)
        end
	end

	def self.executeGrandInstall()
		Gradle.new.executeGradleCommand('installDebug')
	end


	def self.executeGrandTags(vimProxy = VimProxy.new)
        if ProjectControler.hasExuberantCtags()

            TagsHandler.new.generateTagsFile()
            vimProxy.addTagsFile(".tags")

        else
            puts "You need to install Exuberant-Ctags for :GrandTags to work..."
        end
	end

	def self.executeGrandSetup()
		#TODO: check $ANDROID_HOME is set
        # - Check-method in ProjectControler
        # - Call from here
        # - puts message if not set

		if ProjectControler.isGradleProject() and ProjectControler.isAndroidProject()
			configurator = Configurator.new()
			configurator.updatePathFile()

			configurator.setupJavacomplete()
			configurator.setupSyntastic()

			addAllCommands()
		end
	end

    def self.loadTestResults(vimProxy = VimProxy.new)
        result = QuickfixContentGenerator.new.generateQuickfixFromResultXml()
        vimProxy.loadStringToQuickFix(result)
    end

	def self.addAllCommands(proxy = VimProxy.new)
        @vimProxy = proxy
        setupCommand('GrandTags')
		setupCommand('GrandInstall')
	end

end
