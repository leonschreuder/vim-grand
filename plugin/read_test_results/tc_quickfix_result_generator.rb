require "minitest/autorun"

require_relative 'quickfix_result_generator'

class QuickfixResultGeneratorTest < Minitest::Test

    STACKTRACE_EXCERT = '
        at org.junit.Assert.assertEquals(Assert.java:115)
        at nl.leonschreuder.zettel_wirtschaft.AddItemDialogFragmentTest.onSaveListener(AddItemDialogFragmentTest.java:35)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    '

    def setup
        @extractor = QuickfixResultGenerator.new
        @xmlFile = File.open("./plugin/read_test_results/example_test_failing.xml", "r")
    end

    def test_init

        result = @extractor.extract(@xmlFile)

        expected = [
            'src/java/nl/leonschreuder/zettel_wirtschaft/AddItemDialogFragmentTest.java',
            '35',
            'org.junit.ComparisonFailure: EditText value retrieval expected:<[]est> but was:<[t]est>',
        ]
        assert_equal expected.join('|'), result
    end

    def test_parsing

        result = @extractor.extractFailuresFromXml(@xmlFile).first

        assert_equal 'org.junit.ComparisonFailure: EditText value retrieval expected:<[]est> but was:<[t]est>', result[:message]
        assert_equal 'nl.leonschreuder.zettel_wirtschaft.AddItemDialogFragmentTest', result[:classname]
        assert_match(/org\.junit\.ComparisonFailure: .*\n/, result[:trace])
    end

    def test_getLineNumber
        classname = 'nl.leonschreuder.zettel_wirtschaft.AddItemDialogFragmentTest'
        failure = { trace: STACKTRACE_EXCERT, classname: classname}

        result = @extractor.resolveCorrectLineNumberFromFailure(failure)

        assert_equal "35", result
    end
end
