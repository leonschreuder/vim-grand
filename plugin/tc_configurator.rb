
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "configurator"
require_relative "mock_vim"

class StubPathsResolver
	def getAndroidSdkJar(); "~/android.jar"; end
	def getExplodedAarClasses; ["aar1.jar", "aar2.jar"]; end
	def getGeneratedProjectClassPaths; './build/classes'; end
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

		expectedClass = '~/android.jar'
		expectedClass += ':aar1.jar:aar2.jar'
		expectedClass += ':./build/classes'
		expectedClass += ':genA:genB'

		expectedSource = '~/android/sources'
		expectedSource += ':./src/main/:./src/test/'
		expectedSource += ':genA:genB'

		assert_equal "silent! call javacomplete#SetClassPath('#{expectedClass}')", VIM.getCommand()[0]
        assert_equal "silent! call javacomplete#SetSourcePath('#{expectedSource}')", VIM.getCommand()[1]
	end

	def test_setupSyntastic()
		configurator = Configurator.new(StubPathsResolver.new)

		configurator.setupSyntastic()

		syntasticClasses = './src/main/:./src/test/' # ProjectSourcePaths,
		syntasticClasses += ':./build/classes'       # GeneratedProjectClassPaths,
		syntasticClasses += ':genA:genB'             # GradleClassPathsFromFile,
		syntasticClasses += ':~/android.jar'         # AndroidSdkJar,
		syntasticClasses += ':aar1.jar:aar2.jar'     # ExplodedAarClasses

        assert_equal "let $CLASSPATH = '#{ syntasticClasses }'", VIM.getCommand()[0]
	end
end
