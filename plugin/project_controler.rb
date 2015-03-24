require 'find'

class ProjectControler

	def self.isGradleProject()
		return File.exists?("build.gradle")
	end

	def self.isAndroidProject()
		if findFileWithDepth('AndroidManifest.xml', 4)
			return true
		end
		return false
	end

	# regex filename alowed
	def self.findFileWithDepth(filename, depth)
		Find.find("./") { |f|
			if f =~ /.*\/#{filename}$/
				return f
			end
			if f.scan(%r{/}).size > depth
				Find.prune
			end
		}
		return nil
	end
end
