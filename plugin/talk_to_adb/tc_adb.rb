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

		Adb.getDevices()

		assert_equal [Adb.getAdb(), 'devices'], Kernel.getSystem()[0]
	end

	def test_installLatestApk()
		@testTools.mkTestDirs('./build/apk/')
		apkPath = './build/apk/someNew.apk'
		@testTools.createTestFileInPast( apkPath, 30)

		Adb.installLatestApk()

		assert_equal [Adb.getAdb(), 'install', '-r', apkPath], Kernel.getSystem()[0]
	end

	def test_launchApp()
		#TODO
	end

end
