require "testable/situation"

module Testable
  module Pages
    module Attribute
      include Situation

      def url_is(url = nil)
        url_is_empty if url.nil? && url_attribute.nil?
        url_is_empty if url.nil? || url.empty?
        @url = url
      end

      def url_attribute
        @url
      end

      def title_is(title = nil)
        title_is_empty if title.nil? || title.empty?
        @title = title
      end

      def title_attribute
        @title
      end
    end
  end
end
