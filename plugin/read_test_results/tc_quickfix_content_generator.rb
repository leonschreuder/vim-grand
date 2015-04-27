require "minitest/autorun"

require_relative 'quickfix_content_generator'
require_relative '../utils/test_tools'

class QuickfixContentGeneratorTest < Minitest::Test

    STACKTRACE_EXCERT = '
        at org.junit.Assert.assertEquals(Assert.java:115)
        at com.example.project.AddItemDialogFragmentTest.onSaveListener(AddItemDialogFragmentTest.java:35)
        at com.example.project.AddItemDialogFragmentTest.onSaveListener(AddItemDialogFragmentTest.java:45)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
    '

    TEST_SOURCES_DIR = 'plugin/test_sources/'
    TEST_RESULT_DIR = './build/test-results/debug/'

    def setup
        @testTools = TestTools.new
        @quickfixContentGenerator = QuickfixContentGenerator.new
        @xmlFile = File.open("./plugin/test_sources/test_result_failing.xml", "r")
    end

    def teardown
        @testTools.removeTestFilesAndDirs()
    end

    def test_generateQuickfixFromResultXml
        @testTools.copyFileForTest(TEST_SOURCES_DIR + 'test_result_failing.xml', TEST_RESULT_DIR)
        @testTools.copyFileForTest(TEST_SOURCES_DIR + 'test_result_failing2.xml', TEST_RESULT_DIR)

        expectedLine1 = [
            'src/test/java/com/example/project/AddItemDialogFragmentTest.java',
            '35',
            'org.junit.ComparisonFailure: EditText value retrieval expected:<[]est> but was:<[t]est>',
        ]
        expectedLine2 = [
            'src/test/java/com/example/project/model/DbHelperTest.java',
            '89',
            'java.lang.AssertionError',
        ]

        result = @quickfixContentGenerator.generateQuickfixFromResultXml()
        # resultLines = result.split('\n')

        expectedResult = expectedLine1.join(":") + "\n" + expectedLine2.join(":")
        assert_equal expectedResult, result

        # assert_equal 2, resultLines.length
        # assert_equal expectedLine1.join(":"), resultLines[0]
        # assert_equal expectedLine2.join(":"), resultLines[1]
    end

    def test_getTestResultFiles
        file = 'test_result_result.xml'
        @testTools.copyFileForTest(TEST_SOURCES_DIR + file, TEST_RESULT_DIR)

        result = @quickfixContentGenerator.getTestResultFiles()

        assert_equal(TEST_RESULT_DIR + file, result[0])
    end

    def test_extractFailuresFromXml

        result = @quickfixContentGenerator.extractFailuresFromXml(@xmlFile).first

        assert_equal 'org.junit.ComparisonFailure: EditText value retrieval expected:<[]est> but was:<[t]est>', result[:message]
        assert_equal 'com.example.project.AddItemDialogFragmentTest', result[:classname]
        assert_match(/org\.junit\.ComparisonFailure: .*\n/, result[:trace])
    end

    def test_resolveCorrectLineNumberFromFailure
        classname = 'com.example.project.AddItemDialogFragmentTest'
        failure = { trace: STACKTRACE_EXCERT, classname: classname}

        result = @quickfixContentGenerator.findLineNumberForFailure(failure)

        assert_equal "35", result
    end
end
