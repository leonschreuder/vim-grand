require "minitest/autorun"

require_relative "../mock_kernel"
require_relative "../utils/test_tools"
require_relative "adb"

class TestAdb < Minitest::Test

	ANDROID_HOME_VALUE = "stub/android/home"

	def setup()
		Kernel.reinit()
		ENV['ANDROID_HOME'] = ANDROID_HOME_VALUE
		@testTools = TestTools.new()
	end


	def test_getAdb()

		result = Adb.getAdb()

		assert_equal ANDROID_HOME_VALUE+'/platform-tools/adb', result
	end

	def test_getDevices()
        Kernel.backtickReturns "List of devices attached\nR32D202RWKA\tdevice\n\n"

		result = Adb.getDevices()

        assert_equal ["R32D202RWKA\tdevice"], result
	end

	def test_installLatestApk()
		apkPath = './build/apk/someNew.apk'
		@testTools.createTestFileInPast( apkPath, 30)

		Adb.installLatestApk()

		assert_equal [Adb.getAdb(), 'install', '-r', apkPath], Kernel.getSystem()[0]
	end

	def test_launchApp()
		#TODO
	end

end
