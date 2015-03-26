require_relative "find_paths/path_resolver"

class Configurator
	#These are the name of the required get* methods in PathResolver
	@javacomplete_jars = [
		#'AndroidSdkJar',
		#'ExplodedAarClasses',
		#'BuildProjectClassPaths',
		#'GradleClassPathsFromFile',
		]

	@javacomplete_src = [
		#'AndroidSdkSourcePath',
		'ProjectSourcePaths',
		#'GradleClassPathsFromFile',
		]

	@syntastic_paths = [
        'ProjectSourcePaths',
        'BuildProjectClassPaths',
        'GradleClassPathsFromFile',
        'AndroidSdkJar',
        'ExplodedAarClasses'
		]

	attr_accessor :javacomplete_jars
	attr_accessor :javacomplete_src
	attr_accessor :syntastic_paths

	def initialize(pathResolver = PathResolver.new)
		@pathReslover = pathResolver
	end

	#public
	def setupJavacomplete()
		jarsPaths = getPathsFromResolver(@javacomplete_jars)
		sourcePaths = getPathsFromResolver(@javacomplete_src)


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

	# call javacomplete#GetClassPath()
	# call javacomplete#GetSourcePath()
	#private
	def callJavacompleteMethodWithPaths(methodName, pathsArray)
		joinedPaths = pathsArray.join(':')
		p "joined: " + joinedPaths
		VIM.command("silent! call javacomplete##{methodName}('#{ joinedPaths }')")
	end


	#public
	def setupSyntastic()
		paths = getPathsFromResolver(@syntastic_paths)

        #VIM.command("let $CLASSPATH = '" + paths.join(':') + "'")
		#VIM.command("let $CLASSPATH = '#{ paths.join(':') }'")
		VIM.command("let g:syntastic_java_javac_classpath = '#{ paths.join(':') }'")
	end
end
