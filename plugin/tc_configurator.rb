
require "minitest/autorun"

require_relative "utils/test_tools"
require_relative "configurator"
require_relative "mock_vim"

class TestConfigurator < Minitest::Test
	def setup()
		@testTools = TestTools.new()
		@configurator = Configurator.new()
		@android_home_value = "stub/android/home"
		ENV['ANDROID_HOME'] = @android_home_value
		VIM.reinit()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_setupJavacomplete()
		@testTools.createTestFileWithContent(ProjectControler::LIBRARY_PATHS_FILE, "+ path1\nc path2")

		@configurator.setupJavacomplete()

		assert_equal "silent! call javacomplete#SetClassPath('path1:path2')", VIM.getCommand()[0]
	end

	def test_setupSyntastic()
		@testTools.createTestFileWithContent(ProjectControler::LIBRARY_PATHS_FILE, "+ path1\ns path2")

		@configurator.setupSyntastic()

        assert_equal "let g:syntastic_java_javac_classpath = 'path1:path2'", VIM.getCommand()[0]
	end

	def test_updatePathFile()
		@testTools.createTestBuildFile()
		@testTools.createTestFileWithContent(ProjectControler::GRADLE_WRITE_FILE, "path/a:path/b:path/c")

		@configurator.updatePathFile()

		paths = PathFileManager.getPathsFromSourcesFileWithPreceidingChar('+')
		assert paths.include?("./src/main/java"), "Should include static paths"
		assert paths.include?( @android_home_value+"/platforms/android-19/android.jar" ), "Should include dynamic paths"
		assert paths.include?( "path/b" ), "Should include Gradle dependency paths"
	end

end
