
class ProjectSetup

	#protected
	def isGradleProject()
		return File.exists?("build.gradle")
	end

	#protected
	def isAndroidProject()
		Find.find("./") { |f|
			if f =~ /.*\/AndroidManifest.xml$/
				return true
			end
			if f.scan(%r{/}).size > 4
				Find.prune
			end
		}
		return false
	end

	#TODO: Hier war ich
	def searchFileTillDepth(filename, depth)
		Find.find("./") { |f|
			if f =~ /.*\/#{filename}$/
				return true
			end
			if f.scan(%r{/}).size > depth
				Find.prune
			end
		}
		return false
	end
end
