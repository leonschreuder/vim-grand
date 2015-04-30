require 'minitest/autorun'

require_relative 'quick_fix_filter'

class QuickFixFilterTest < Minitest::Test

    MAIN_FAILURE_IN = "com.example.some_project.model.DbHelperTest > onCreateCreatesLists FAILED"
    MAIN_FAILURE_OUT = "src/test/java/com/example/some_project/model/DbHelperTest.java > onCreateCreatesLists FAILED"
    MAIN_CLOSE_MATCH_1 = ":testDebug FAILED"
    MAIN_CLOSE_MATCH_2 = "BUILD FAILED"

    STANDARD_OUTPUT_IN = "com.example.some_project.display_right_pane.display_single_chart.ArchivedChartFragmentTest > clickingCalendarButtonDisplaysCalendar STANDARD_OUT"
    STANDARD_OUTPUT_OUT = "src/test/java/com/example/some_project/display_right_pane/display_single_chart/ArchivedChartFragmentTest.java > clickingCalendarButtonDisplaysCalendar STANDARD_OUT"

    STANDARD_ERROR_IN = "com.example.some_project.display_right_pane.display_single_chart.ArchivedChartFragmentTest > clickingCalendarButtonDisplaysCalendar STANDARD_ERROR"
    STANDARD_ERROR_OUT = "src/test/java/com/example/some_project/display_right_pane/display_single_chart/ArchivedChartFragmentTest.java > clickingCalendarButtonDisplaysCalendar STANDARD_ERROR"
    
FAILURE_COMPLETE_IN = "com.example.some_project.model.DbHelperTest > onCreateCreatesLists FAILED
    java.lang.AssertionError: File 'service_archivwind-2015-04-29.inc' should have downloaded to specified location
        at org.junit.Assert.fail(Assert.java:88)
        at org.junit.Assert.assertTrue(Assert.java:41)
        at de.fuenfzig_hertz.eeg_app.display_right_pane.display_single_chart.ArchivedChartFragmentTest.assertFileExistsOnSystem(ArchivedChartFragmentTest.java:85)
        at de.fuenfzig_hertz.eeg_app.display_right_pane.display_single_chart.ArchivedChartFragmentTest.onDateSetShouldDownloadAndShowTheCorrectFile(ArchivedChartFragmentTest.java:65)
"
FAILURE_COMPLETE_OUT = "src/test/java/com/example/some_project/model/DbHelperTest.java > onCreateCreatesLists FAILED
    java.lang.AssertionError: File 'service_archivwind-2015-04-29.inc' should have downloaded to specified location
        at org.junit.Assert.fail(Assert.java:88)
        at org.junit.Assert.assertTrue(Assert.java:41)
        at de.fuenfzig_hertz.eeg_app.display_right_pane.display_single_chart.ArchivedChartFragmentTest.assertFileExistsOnSystem(ArchivedChartFragmentTest.java:85)
        at de.fuenfzig_hertz.eeg_app.display_right_pane.display_single_chart.ArchivedChartFragmentTest.onDateSetShouldDownloadAndShowTheCorrectFile(ArchivedChartFragmentTest.java:65)
"


    def test_convertsFailureLineToFilePath()
        filter = QuickFixFilter.new

        out = capture_io do
            filter.filterLine(MAIN_FAILURE_IN)
        end

        assert_equal MAIN_FAILURE_OUT + "\n", out[0]
    end

    def test_ignoresCloseMatches()
        filter = QuickFixFilter.new

        out = capture_io do
            filter.filterLine(MAIN_FAILURE_IN)
            filter.filterLine("")
            filter.filterLine(MAIN_CLOSE_MATCH_1)
            filter.filterLine(MAIN_CLOSE_MATCH_2)
        end

        assert_equal MAIN_FAILURE_OUT + "\n", out[0]
    end

    def test_capturesEntireErrorMessage()
        filter = QuickFixFilter.new

        out = capture_io do
            filter.filterLine(MAIN_CLOSE_MATCH_1)
            FAILURE_COMPLETE_IN.each_line do |line|
                filter.filterLine(line)
            end
            filter.filterLine("")
            filter.filterLine(MAIN_CLOSE_MATCH_2)
        end

        assert_equal FAILURE_COMPLETE_OUT, out[0]
    end

    def test_outputsStandardOut()
        filter = QuickFixFilter.new

        out = capture_io do
            filter.filterLine(STANDARD_OUTPUT_IN)
            filter.filterLine(STANDARD_ERROR_IN)
        end

        assert_equal STANDARD_OUTPUT_OUT + "\n" + STANDARD_ERROR_OUT + "\n", out[0]
    end

end
