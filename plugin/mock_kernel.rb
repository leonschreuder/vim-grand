
# Mock
module Kernel
	def self.reinit()
		@@spawned = []
		@@system = []
		@@fork = []
	end

	def self.spawn(*arg)
		p 'spawned with: ' + arg.to_s
		@@spawned = arg
		return 0
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
