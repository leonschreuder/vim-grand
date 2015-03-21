# This is a mock for the VIM module. As the VIM module is not defined when
# running the tests, ruby will simply use this class in its place.
class VIM
	@@evaluateResult = false

	def self.reinit()
		@commandInput = []
		@evaluateInput = []
		@@evaluateResult = false
	end

	def self.command(someString)
		@commandInput.push(someString)
	end

	def self.getCommand()
		return @commandInput
	end

	def self.setEvaluateResult(result)
		@@evaluateResult = result
	end

	def self.evaluate(evl)
		@evaluateInput.push(evl)
		return @@evaluateResult
	end

	def self.getEvaluate()
		return @evaluateInput
	end
end
