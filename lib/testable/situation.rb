require "testable/errors"

module Testable
  module Situation
    private

    def url_is_empty
      puts "PROBLEM: url_is attribute empty.\n" \
      "The url_is attribute is empty on the definition " \
      "'#{retrieve_class(caller)}'.\n\n"
      raise Testable::Errors::NoUrlForDefinition
    end

    def retrieve_class(caller)
      caller[1][/`.*'/][8..-3]
    end
  end
end
