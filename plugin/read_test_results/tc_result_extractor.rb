
require "minitest/autorun"

#https://developer.yahoo.com/ruby/ruby-xml.html

require_relative "result_extractor"

class ResultExtractorTest < Minitest::Test

    def test_init
        extractor = ResultExtractor.new

        f = File.open("./plugin/read_test_results/example_test_failing.xml", "r")

        result = extractor.extract(f)

        assert_equal result, "nl.leonschreuder.zettel_wirtschaft.AddItemDialogFragmentTest"
    end

end

#TODO: Next step: force xml-reading by supplying another xml file

# Ggrep result:
# path/relative/to/Cwd.java|19| erorous line

# Gradle commandline output:
#nl.leonschreuder.zettel_wirtschaft.AddItemDialogFragmentTest > onSaveListener FAILED
#    org.junit.ComparisonFailure at AddItemDialogFragmentTest.java:35

# Ruby error:
#plugin/read_test_results/tc_result_extractor.rb|6 error| cannot load such file -- /Users/admin/.vim/bundle/vim-grand/plugin/read_test_results/result_extracto (LoadError)
