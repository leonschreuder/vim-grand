
require "minitest/autorun"

require_relative "utils/test_tools"
require_relative "configurator"
require_relative "mock_vim"
require_relative "project_controler"

class StubVimProxy < VimProxy
    attr_accessor :setGlobalVariableToValueArg
    attr_accessor :callVimMethodArg

    def setGlobalVariableToValue(variableName, value)
        @setGlobalVariableToValueArg = [variableName, value]
    end

    def callVimMethod(methodName, args)
        @callVimMethodArg = [methodName, args]
    end
end

class TestConfigurator < Minitest::Test
	def setup()
		@testTools = TestTools.new()
        @vimProxy = StubVimProxy.new()
		@configurator = Configurator.new(@vimProxy)
		@android_home_value = "stub/android/home"
		ENV['ANDROID_HOME'] = @android_home_value
		VIM.reinit()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_setupSyntastic()
		@testTools.createTestFileWithContent(ProjectControler::PATH_FILE, "+ path1\ns path2")

		@configurator.setupSyntastic()

        assert_equal ["syntastic_java_javac_classpath", "'path1:path2'"], @vimProxy.setGlobalVariableToValueArg
	end

	def test_setupJavacomplete()
		@testTools.createTestFileWithContent(ProjectControler::PATH_FILE, "+ path1\nc path2")

		@configurator.setupJavacomplete()

        assert_equal ["javacomplete#SetClassPath", "'path1:path2'"], @vimProxy.callVimMethodArg
	end

	def test_updatePathFile()
		@testTools.createTestBuildFile()
		@testTools.createTestFileWithContent(ProjectControler::GRADLE_WRITE_FILE, "path/a:path/b:path/c")

		@configurator.updatePathFile()

		paths = PathFileManager.retrievePathsWithPreceidingChar('+')
		assert paths.include?("./src/main/java"), "Should include static paths"
		assert paths.include?( @android_home_value+"/platforms/android-19/android.jar" ), "Should include dynamic paths"
		assert paths.include?( "path/b" ), "Should include Gradle dependency paths"
		@testTools.deleteFileIfExists(ProjectControler::PATH_FILE)
	end

end
