require 'rexml/document'

class QuickfixContentGenerator

    def generateQuickfixFromResultXml()
        resultFiles = getTestResultFiles()

        failures = getAllFailuresFromFiles(resultFiles)

        return generateQuickfixContentFromFailures(failures)
    end

    def getTestResultFiles
        return Dir.glob('./build/test-results/debug/*.xml')
    end

    def getAllFailuresFromFiles(files)
        failures = []
        files.each { |file|
            failures += extractFailuresFromXml(file)
        }
        return failures
    end

    def extractFailuresFromXml(filePath)
        file = File.open(filePath)
        doc = REXML::Document.new(file)
        failures = []

        doc.elements.each('testsuite/testcase') { |testcase|
            failure = testcase.elements['failure']
            if failure
                resultHash = {}
                resultHash.store(:classname, testcase.attributes['classname'])
                resultHash.store(:message, failure.attributes['message'])
                resultHash.store(:trace, failure.text)
                failures << resultHash
            end
        }

        return failures
    end


    def generateQuickfixContentFromFailures(failures)
        lines = []
        failures.each { |failure|
            lines << generateQuickfixLineFromFailure(failure)
        }
        return lines.join('\n')
    end

    def generateQuickfixLineFromFailure(failure)
        fileName = getFileNameFromFailure(failure)
        lineNumber = findLineNumberForFailure(failure)
        message = failure[:message]

        quickFixMessage = [
            fileName ,
            lineNumber ,
            message ,
        ]
        return quickFixMessage.join('|')
    end

    def getFileNameFromFailure(failure)
        className = failure[:classname]
        return "src/java/" + className.gsub('.', '/') + '.java'
    end

    def findLineNumberForFailure(failure)
        classname = failure[:classname]
        trace = failure[:trace]

        rightLine = ""
        trace.each_line { |line|
            if line =~ /#{Regexp.escape classname}/
                rightLine = line
                break
            end
        }

        return rightLine.match(/(?!\(.*)\d+/)[0]
    end

end
