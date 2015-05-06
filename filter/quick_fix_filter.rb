#!/usr/bin/env ruby

require 'optparse'
$verbose = false

class QuickFixFilter
    @readingFailureInProgress = false

    def filterLine(line)
        if lineIsImportantMessage(line)
            @readingFailureInProgress = true

            printLineWithPackageNameAsFilePath(line)

        elsif @readingFailureInProgress

            continuePrintingUntilWhiteLine(line)
        elsif $verbose
            puts line
        end
    end

    def lineIsImportantMessage(line)
        return line =~ />.*FAILED$/ || line =~ />.*STANDARD_OUT/ || line =~ />.*STANDARD_ERROR/
    end

    def continuePrintingUntilWhiteLine(line)
        if /^\s*$/ !~ line
            puts line
        else
            @readingFailureInProgress = false
        end
    end

    def printLineWithPackageNameAsFilePath(packagString)
        whole_words = packagString.split(" ")

        slashedPackage = whole_words[0].gsub(/\./, "\/")
        whole_words[0] = "src/test/java/" + slashedPackage + ".java"

        puts whole_words.join(" ")
    end

    def self.getScriptPath()
        return File.expand_path(__FILE__)
    end
end

if __FILE__==$0
    # this will only run if the script was the main, not load'd or require'd

    OptionParser.new do |opts|
        opts.on '-v', '--verbose', 'Print verbose messages' do
            puts "Verbose"
            $verbose = true
        end
    end.parse!

    puts "Build started"
    # puts __FILE__

    quickFilter = QuickFixFilter.new
    $stdin.each_line do |line|
        quickFilter.filterLine(line)
    end

    t = Time.new
    puts "Build completed at " + t.strftime("%H:%M")
end
