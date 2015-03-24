require_relative "find_paths/path_resolver"

class Configurator
	#These are the name of the required get* methods in PathResolver
	@@javacomplete_jars = [
		'AndroidSdkJar',
		'ExplodedAarClasses',
		'GeneratedProjectClassPaths',
		'GradleClassPathsFromFile']
	@@javacomplete_src = [
		'AndroidSdkSourcePath',
		'ProjectSourcePaths',
		'GradleClassPathsFromFile']
	@@syntastic_paths = 
        'ProjectSourcePaths',
        'GeneratedProjectClassPaths',
        'GradleClassPathsFromFile',
        'AndroidSdkJar',
        'ExplodedAarClasses'

	def initialize(pathResolver = PathResolver.new)
		@pathReslover = pathResolver
	end

	#public
	def setupJavacomplete()
		jarsPaths = getPathsFromResolver(@@javacomplete_jars)
		sourcePaths = getPathsFromResolver(@@javacomplete_src)


		callJavacompleteMethodWithPaths('SetClassPath', jarsPaths)
		callJavacompleteMethodWithPaths('SetSourcePath', sourcePaths)
	end

	#private
	def getPathsFromResolver(pathsArray)
		foundPaths = []
		pathsArray.each do |requestedPath|
			p "hier: "+requestedPath
			foundPaths << @pathReslover.send('get' + requestedPath)
		end
		return foundPaths
	end

	#private
	def callJavacompleteMethodWithPaths(methodName, pathsArray)
		joinedPaths = pathsArray.join(':')
		VIM.command("silent! call javacomplete##{methodName}('#{ joinedPaths }')")
	end


	#public
	def setupSyntastic()
		paths = getPathsFromResolver(@@syntastic_paths)

        VIM.command("let $CLASSPATH = '" + paths.join(':') + "'")
		VIM.command("let $CLASSPATH = '#{ paths.join(':') }'")
	end
end
