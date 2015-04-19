require_relative "../project_controler"

class TestTools

    def initialize()
        @testFiles = []
        @testDirs = []
    end

    # public
    def createTestFileWithContent(path, content)
        @testFiles.push(path)

        file = splitFileAndPath(path)

        mkTestDirs(file[0])
        if file[1] != ""
            File.open(path, 'w') {|f|
                f.write(content)
            }
        end
    end

    # public
    def mkTestDirs(path)
        @testDirs.push(path)
        FileUtils.mkpath(path) if not File.exist?(path)
    end

    # public
    def createTestFile(path)
        @testFiles.push(path)
        createTestFileWithContent(path, "")
    end

    # private
    def splitFileAndPath(path)
        sep = File::SEPARATOR
        if not path.start_with?(sep)
            path = "." + sep + path
        end
        path.split(/#{sep}(?!.*#{sep})/, -1)
    end

    def copyFileForTest(source, targetDir)
        mkTestDirs(targetDir)
        @testFiles.push targetDir + splitFileAndPath(source)[1]
        FileUtils.copy(source, targetDir)
    end

    # public
    def createTestFileInPast(path, timeInPast)
        createTestFile(path)
        FileUtils.touch path, :mtime => Time.now - timeInPast
    end

    # public
    def createTestBuildFile()
        content = [
            "    }\n",
            "    compileSdkVersion 19\n",
            "    buildToolsVersion \"19.1.0\"\n",
            "\n",
            "    defaultConfig {\n"
        ]

        createTestFileWithContent(ProjectControler::GRADLE_BUILD_FILE, content.join)
    end


    # Removing
    #--------------------------------------------------------------------------------
    def removeTestFilesAndDirs()
        removeTestFiles()
        removeTestDirs()
    end

    def removeTestFiles()
        @testFiles.each do |file|
            deleteFileIfExists(file)
        end
    end

    def deleteFileIfExists(file)
        begin
            File.delete(file)
        rescue
            #File already gone
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
