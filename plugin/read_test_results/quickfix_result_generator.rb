require 'rexml/document'

class QuickfixResultGenerator

    def extract(file)
        failures = extractFailuresFromXml(file)

        return quickfixMessageFromFailures(failures)
    end

    def extractFailuresFromXml(file)
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

    def quickfixMessageFromFailures(failures)
        lines = []
        failures.each { |failure|
            lines << quickfixLineFromFailure(failure)
        }
        return lines.join('\n')
    end

    def quickfixLineFromFailure(failure)

        fileName = resolveFileNameFromFailure(failure)
        lineNumber = resolveCorrectLineNumberFromFailure(failure)
        message = failure[:message]

        quickFixMessage = [
            fileName ,
            lineNumber ,
            message ,
        ]
        return quickFixMessage.join('|')
    end

    def resolveFileNameFromFailure(failure)
        className = failure[:classname]
        return "src/java/" + className.gsub('.', '/') + '.java'
    end

    def resolveCorrectLineNumberFromFailure(failure)
        classname = failure[:classname]
        trace = failure[:trace]

        rightLine = ""
        trace.each_line { |line|
            if line =~ /#{Regexp.escape classname}/
                rightLine = line
            end
        }

        return rightLine.match(/(?!\(.*)\d+/)[0]
    end

end
