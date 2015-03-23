
require "minitest/autorun"
require_relative "utils/test_tools"
require_relative "project_setup"
require_relative "mock_vim"

class MockPathsResolver
	def getAllClassPaths()
		return ['path1','path2']
	end
	def getExplodedAarClasses()
		return ['src/test','src/main']
	end
	def getAndroidSdkJar()
		return 'AndroidSdkJar'
	end
	def getProjectSourcePaths()
		return ['src/test','src/main']
	end
	def getGradleClassPathsFromFile()
		return ['src/test','src/main']
	end
	def getGeneratedProjectClassPaths()
		return ['src/test','src/main']
	end
	def getAndroidSdkSourcePath()
		return '/android/source/'
	end
end

class TestProjectSetup < Minitest::Test
	def setup()
		@testTools = TestTools.new()
	end

	def teardown()
		@testTools.removeTestFilesAndDirs()
	end


	def test_setupJavacomplete()
		#ps = ProjectSetup.new
		#ps.send(:attr_accessor, :pathReslover, MockPathsResolver.new)
		#ps.tryout()
	end

	def test_isGradleProject()
		@testTools.createTestBuildFile()

		result = ProjectSetup.new.isGradleProject()

		assert result, "Should returned true"
	end

	def test_isAndroidProject()
		@testTools.mkTestDirs("./src/main/")
		@testTools.createTestFile("./src/main/AndroidManifest.xml")

		result = ProjectSetup.new.isAndroidProject()

		assert result, "Should returned true"
	end
end
