require_relative "../find_paths/path_resolver"

class Adb

	def self.getAdb()
		androidHome = PathResolver.new.getAndroidHome()

		return File.join(androidHome, "platform-tools", "adb")
	end

	def self.getDevices()
		stdout = `#{getAdb()} devices`
        return stdout.split("\n")[1..-1]
	end

	def self.installLatestApk()
		latestApk = PathResolver.new.getLatestApkFile()
		Kernel.system( [getAdb(), "install", "-r", latestApk])
	end
end



# IntelliJ porcess:

#Target device: samsung-nexus_10-R32D202RWKA
#Uploading file
    #local path: /Users/lschreuder/Documents/workspace/50hertz_app/build/outputs/apk/50hertz_app-debug-1.1.2.apk
        #remote path: /data/local/tmp/de.fuenfzig_hertz.eeg_app
        #Installing de.fuenfzig_hertz.eeg_app
        #DEVICE SHELL COMMAND: pm install -r "/data/local/tmp/de.fuenfzig_hertz.eeg_app"
        #pkg: /data/local/tmp/de.fuenfzig_hertz.eeg_app
        #Success


        #Launching application: de.fuenfzig_hertz.eeg_app/de.fuenfzig_hertz.eeg_app.MainActivity.
        #DEVICE SHELL COMMAND: am start -n "de.fuenfzig_hertz.eeg_app/de.fuenfzig_hertz.eeg_app.MainActivity" -a android.intent.action.MAIN -c android.intent.category.LAUNCHER
        #Starting: Intent { act=android.intent.action.MAIN cat=[android.intent.category.LAUNCHER] cmp=de.fuenfzig_hertz.eeg_app/.MainActivity }
