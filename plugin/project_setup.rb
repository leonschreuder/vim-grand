require_relative "find_paths/path_resolver"

class ProjectSetup

	def initialize()
		@pathReslover = PathResolver.new
	end

	#def tryout()
		#puts @pathReslover
	#end


	#protected
	def isGradleProject()
		return File.exists?("build.gradle")
	end

	#protected
	def isAndroidProject()
		if findFileWithDepth('AndroidManifest.xml', 4)
			return true
		end
		return false
	end

	# regex filename alowed
	def findFileWithDepth(filename, depth)
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
