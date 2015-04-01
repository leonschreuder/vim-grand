require "minitest/autorun"

class TestAdb < Minitest::Test

	ANDROID_HOME_VALUE = "stub/android/home"

	def setup()
		ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
	end


	def test_something()
	end
end
