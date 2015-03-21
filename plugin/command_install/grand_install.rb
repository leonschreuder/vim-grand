
require_relative "../talk_to_gradle/gradle"
class GrandInstall

	def executeCommand()
		Gradle.new.executeGradleCommand('installDebug')
	end

end
