
require_relative "find_paths/path_resolver"
require_relative "find_paths/path_file_manager"
require_relative "vim_proxy"

class Configurator

    def initialize(vimProxy = VimProxy.new)
        @vimProxy = vimProxy
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

        @vimProxy.setGlobalVariableToValue("syntastic_java_javac_classpath", "'#{ paths.join(':') }'")
    end

    def updatePathFile()
        paths  = @pathResolver.getStaticPaths()
        paths += @pathResolver.getDynamicPaths()
        paths += @pathResolver.loadGradleDependencyPaths()
        PathFileManager.writeOutPaths(paths)
    end


    private
    def callJavacompleteMethodWithPaths(methodName, pathsArray)
        joinedPaths = pathsArray.join(':')
        @vimProxy.callVimMethod("javacomplete#" + methodName, "'#{ joinedPaths }'")
    end

end
