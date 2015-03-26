
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "configurator"
require_relative "mock_vim"

class StubPathsResolver
	def getAndroidSdkJar(); "~/android.jar"; end
	def getExplodedAarClasses; ["aar1.jar", "aar2.jar"]; end
	def getBuildProjectClassPaths; './build/classes'; end
	def getGradleClassPathsFromFile; ['genA', 'genB']; end
	def getAndroidSdkSourcePath; '~/android/sources'; end
	def getProjectSourcePaths; ['./src/main/', './src/test/']; end
end

class TestConfigurator < Minitest::Test
	def setup()
		VIM.reinit()
	end

	def teardown()
	end


	def test_setupJavacomplete()
		configurator = Configurator.new(StubPathsResolver.new)

		configurator.setupJavacomplete()

		jarsPaths = configurator.getPathsFromResolver(Configurator::JAVACOMPLETE_JARS )
		sourcePaths = configurator.getPathsFromResolver(Configurator::JAVACOMPLETE_SRC )

		expectedClass = jarsPaths.join(':')
		expectedSource = sourcePaths.join(':')

		assert_equal "silent! call javacomplete#SetClassPath('#{expectedClass}')", VIM.getCommand()[0]
        assert_equal "silent! call javacomplete#SetSourcePath('#{expectedSource}')", VIM.getCommand()[1]
	end

	def test_setupSyntastic()
		configurator = Configurator.new(StubPathsResolver.new)

		configurator.setupSyntastic()

		syntasticClasses = './src/main/:./src/test/' # ProjectSourcePaths,
		syntasticClasses += ':./build/classes'       # BuildProjectClassPaths,
		syntasticClasses += ':genA:genB'             # GradleClassPathsFromFile,
		syntasticClasses += ':~/android.jar'         # AndroidSdkJar,
		syntasticClasses += ':aar1.jar:aar2.jar'     # ExplodedAarClasses

        assert_equal "let g:syntastic_java_javac_classpath = '#{ syntasticClasses }'", VIM.getCommand()[0]
	end
end
