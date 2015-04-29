require 'minitest/autorun'

require_relative 'quick_fix_filter_tested'

class QuickFixFilterTest < Minitest::Test

    FAILED_LINE = "com.example.some_project.model.DbHelperTest > onCreateCreatesLists FAILED"


    def test_test()
        filter = QuickFixFilter.new

        filter.filterLine(FAILED_LINE)

        refute_nil filter
    end

end
