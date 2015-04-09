
# Mock
module Kernel
	def self.reinit()
		@@spawned = []
		@@system = []
	end

	def self.spawn(*arg)
		@@spawned = arg
		return 1
	end

	def self.getSpawned()
		return @@spawned
	end

	def self.system(*arg)
		@@system = arg
	end
	def self.getSystem()
		return @@system
	end

end
