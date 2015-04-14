
require_relative "find_paths/path_resolver"
require_relative "find_paths/path_file_manager"

class Configurator

	#These are the name of the get* methods in PathResolver to add as a source
	#JAVACOMPLETE_JARS = [
		#'ProjectSourcePaths', # Results in adding import package completion for project
		#'BuildProjectClassPaths',
		#'AndroidSdkJar',
		#'ExplodedAarClasses', # Results in adding support package for import completion
		#'CompletionPathsFromSourcesFile',
		#'GradleClassPathsFromFile', # Results in adding regular completion for Robolectric (seems to add slowness inside Tests)
		#]

	#JAVACOMPLETE_SRC = [
		#'BuildProjectClassPaths',
		#'ExplodedAarClasses', # Results in adding support package for class completion
		#'AndroidSdkJar',
		#'AndroidSdkSourcePath',
		#'ProjectSourcePaths',
		#'GradleClassPathsFromFile',
		#]

	# Correct imports don't seem to apply to test-classes

	#SYNTASTIC_PATHS = [
        #'ProjectSourcePaths',
        #'BuildProjectClassPaths',
		#'SyntasticPathsFromSourcesFile', # replaces 'GradleClassPathsFromFile',
        #'AndroidSdkJar',
        #'ExplodedAarClasses'
		#]

	def initialize()
		@pathResolver = PathResolver.new
	end

	def setupJavacomplete()
		paths = []
		paths += PathFileManager.retrievePathsWithPreceidingChar('+')
		paths += PathFileManager.retrievePathsWithPreceidingChar('c')

		callJavacompleteMethodWithPaths('SetClassPath', paths)
	end

	def setupSyntastic()
		paths = []
		paths += PathFileManager.retrievePathsWithPreceidingChar('+')
		paths += PathFileManager.retrievePathsWithPreceidingChar('s')

		VIM.command("let g:syntastic_java_javac_classpath = '#{ paths.join(':') }'")
	end

	def updatePathFile()
		paths  = @pathResolver.getStaticPaths()
		paths += @pathResolver.getDynamicPaths()
		paths += @pathResolver.loadGradleDependencyPaths()
		PathFileManager.writeOutPaths(paths)
	end


	#private
	def callJavacompleteMethodWithPaths(methodName, pathsArray)
		joinedPaths = pathsArray.join(':')
		VIM.command("silent! call javacomplete##{methodName}('#{ joinedPaths }')")
	end

end
