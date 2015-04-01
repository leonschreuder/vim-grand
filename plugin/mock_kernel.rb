
# Mock
module Kernel
	def self.reinit()
		@@system = []
	end

	def self.spawn(*arg)
		@@spawned = arg
		return 1
	end

	def self.getSpawned()
		return @@spawned
	end
end
