module Testable
  module Errors
    NoUrlForDefinition = Class.new(StandardError)
    NoUrlMatchForDefinition = Class.new(StandardError)
    NoUrlMatchPossible = Class.new(StandardError)
    NoTitleForDefinition = Class.new(StandardError)
  end
end
