require_relative "find_paths/path_resolver"

class Configurator
	#These are the name of the get* methods in PathResolver to add as a source
	JAVACOMPLETE_JARS = [
		'ProjectSourcePaths', # Results in adding import package completion for project
		'BuildProjectClassPaths',
		'AndroidSdkJar',
		'ExplodedAarClasses', # Results in adding support package for import completion
		'GradleClassPathsFromFile', # Results in adding regular completion for Robolectric (seems to add slowness inside Tests)
		]

	JAVACOMPLETE_SRC = [
		'BuildProjectClassPaths',
		'ExplodedAarClasses', # Results in adding support package for class completion
		#'AndroidSdkJar',
		#'AndroidSdkSourcePath',
		#'ProjectSourcePaths',
		#'GradleClassPathsFromFile',
		]

	# Correct imports don't seem to apply to test-classes

	SYNTASTIC_PATHS = [
        'ProjectSourcePaths',
        'BuildProjectClassPaths',
        'GradleClassPathsFromFile',
        'AndroidSdkJar',
        'ExplodedAarClasses'
		]

	def initialize(pathResolver = PathResolver.new)
		@pathReslover = pathResolver
	end

	#public
	def setupJavacomplete()
		jarsPaths = getPathsFromResolver(JAVACOMPLETE_JARS)
		sourcePaths = getPathsFromResolver(JAVACOMPLETE_SRC)

		callJavacompleteMethodWithPaths('SetClassPath', jarsPaths)
		callJavacompleteMethodWithPaths('SetSourcePath', sourcePaths)
	end

	#protected
	def getPathsFromResolver(pathsArray)
		foundPaths = []
		pathsArray.each { |requestedPath|
			foundPaths << @pathReslover.send('get' + requestedPath)
		}
		return foundPaths
	end

	#private
	def callJavacompleteMethodWithPaths(methodName, pathsArray)
		joinedPaths = pathsArray.join(':')
		VIM.command("silent! call javacomplete##{methodName}('#{ joinedPaths }')")
	end


	#public
	def setupSyntastic()
		paths = getPathsFromResolver(SYNTASTIC_PATHS)

		VIM.command("let g:syntastic_java_javac_classpath = '#{ paths.join(':') }'")
	end
end
