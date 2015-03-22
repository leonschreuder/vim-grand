
# Mock
module Kernel
	def self.reinit()
		@@spawned = []
	end

	def self.spawn(*arg)
		@@spawned = arg
		return 0
	end

	def self.getSpawned()
		return @@spawned
	end
end
