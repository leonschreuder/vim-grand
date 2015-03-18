
class TestTools

	def initialize()
		@testFiles = []
		@testDirs = []
	end

	def buildTestSourcesFile
		@testFiles.push('gradle-sources')
		File.open("gradle-sources", 'w') {|f|
			f.write("/path/a\n/path/b")
		}
	end

	def createTestFileInPast(path, timeInPast)
		@testFiles.push(path)
		FileUtils.touch path, :mtime => Time.now - timeInPast
	end

	def createTestFile(path)
		@testFiles.push(path)
		FileUtils.touch path
	end

	def mkTestDirs(path)
		@testDirs.push(path)
		FileUtils.mkdir_p(path)
	end

	def createTestBuildFile()
		@testFiles.push('build.gradle')
		File.open("build.gradle", "w") { |f|
			f.write("	 }\n" \
					"	 compileSdkVersion 19\n" \
					"	 buildToolsVersion \"19.1.0\"\n" \
					"\n" \
					"	 defaultConfig {\n"
			)
		}
	end


	def removeTestFilesAndDirs()
		removeTestFiles()
		removeTestDirs()
	end

	def removeTestFiles()
		@testFiles.each do |file|
			File.delete(file)
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
			Dir.rmdir(currentDir)
		rescue
			# Dir non empty. Just ignore.
		end
	end

end
