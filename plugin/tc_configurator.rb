
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
		@configurator = Configurator.new(StubPathsResolver.new)
		VIM.reinit()
	end


	def test_setupJavacomplete()
		expectedClass = findPathsFor(Configurator::JAVACOMPLETE_JARS)
		expectedSource = findPathsFor(Configurator::JAVACOMPLETE_SRC)

		@configurator.setupJavacomplete()

		assert_equal "silent! call javacomplete#SetClassPath('#{expectedClass}')", VIM.getCommand()[0]
        assert_equal "silent! call javacomplete#SetSourcePath('#{expectedSource}')", VIM.getCommand()[1]
	end

	def test_setupSyntastic()
		expectedPaths = findPathsFor(Configurator::SYNTASTIC_PATHS)

		@configurator.setupSyntastic()

        assert_equal "let g:syntastic_java_javac_classpath = '#{ expectedPaths }'", VIM.getCommand()[0]
	end

	def findPathsFor(const)
		@configurator.getPathsFromResolver(const).join(':')
	end
end
