# This is a mock for the VIM module. As the VIM module is not defined when
# running the tests, ruby will simply use this class in its place.
class VIM

	def self.reinit()
		@commandInput = []
		@evaluateInput = []
		@evaluateResult = []
	end

	def self.command(someString)
		@commandInput.push(someString)
	end

	def self.getCommand()
		return @commandInput
	end

	def self.setEvaluateResult(*result)
        result.each { |singleResult|
            @evaluateResult << singleResult
        }
	end

	def self.evaluate(evl)
		@evaluateInput.push(evl)

        # this guards us for unexpected calls and sideeffects from those
        result = @evaluateResult.pop()
        if result == nil
            raise "VIM::evaluate was unexpectedly called with "+evl
        end
		return result
	end

	def self.getEvaluate()
		return @evaluateInput
	end
end
