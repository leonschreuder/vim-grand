class Thread
	def self.reinit()
		@@initialized = false
	end

	def initialize
		@@initialized = true
	end

	def self.wasInitialized
		p 'initialized = ' + @@initialized.to_s
		return @@initialized
	end
end
