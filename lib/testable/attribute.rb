require "testable/situation"

module Testable
  module Pages
    module Attribute
      include Situation

      def url_is(url = nil)
        url_is_empty if url.nil? && url_attribute.nil?
      end

      def url_attribute
        @url
      end
    end
  end
end
