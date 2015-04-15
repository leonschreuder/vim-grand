
require_relative "find_paths/path_resolver"
require_relative "find_paths/path_file_manager"

class Configurator

    def initialize()
        @pathResolver = PathResolver.new
    end

    def setupJavacomplete()
        paths = []
        paths += PathFileManager.retrievePathsWithPreceidingChar('+')
        paths += PathFileManager.retrievePathsWithPreceidingChar('c')

        # Currently only the class paths are set. This seems to have no
        # downsides in completion
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
