
class TestTools

	def initialize()
		@testFiles = []
		@testDirs = []
	end

	def mkTestDirs(path)
		@testDirs.push(path)
		FileUtils.mkdir_p(path)
	end

	def createTestFile(path)
		@testFiles.push(path)
		FileUtils.touch path
	end

	def createTestFileWithContent(path, content)
		@testFiles.push(path)

		File.open(path, 'w') {|f|
			f.write(content)
		}
	end

	def createTestFileInPast(path, timeInPast)
		@testFiles.push(path)
		FileUtils.touch path, :mtime => Time.now - timeInPast
	end


	def buildTestSourcesFile
		content = [
			"+ /path/plus\n",
			"- /path/minus\n",
			"s /path/syntastic\n",
			"c /path/completion"
		]

		createTestFileWithContent(ProjectControler::LIBRARY_PATHS_FILE, content.join)
	end

	def createTestBuildFile()
		content = [
			"	 }\n",
			"	 compileSdkVersion 19\n",
			"	 buildToolsVersion \"19.1.0\"\n",
			"\n",
			"	 defaultConfig {\n"
		]

		createTestFileWithContent(ProjectControler::GRADLE_BUILD_FILE, content.join)
	end


	# Removing
	def removeTestFilesAndDirs()
		removeTestFiles()
		removeTestDirs()
	end

	def removeTestFiles()
		@testFiles.each do |file|
			begin
				File.delete(file)
			rescue
				#File already gone
			end
		end
	end

	def removeTestDirs()
		# This removes all created (sub)dirs (now empty) in the specified path
		@testDirs.each do |testDir|
			folderArray = testDir.split(File::SEPARATOR)

			indexes = (0 .. folderArray.length-1)
			indexes.reverse_each do |i|
				currentDir = File.join(folderArray[0,i+1])

				rmdirWhenEmpty(currentDir)
			end
		end
	end

	def rmdirWhenEmpty(dir)
		begin
			Dir.rmdir(dir)
		rescue
			# Dir non empty. Just ignore.
		end
	end

end
