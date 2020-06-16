require "testable/situation"

module Testable
  module Pages
    module Attribute
      include Situation

      # This is an attribute that can be specified on a model, such as a page
      # object. When this attribute is provided, the model will have a URL
      # that can be navigated to automatically by Testable.
      def url_is(url = nil)
        url_is_empty if url.nil? && url_attribute.nil?
        url_is_empty if url.nil? || url.empty?
        @url = url
      end

      # This allows a test to query for the url attribute that was set on the
      # model. It's important to note that this is not the actual URL in the
      # browser, but rather whatever was created on the model.
      def url_attribute
        @url
      end

      # This is an attribute that can be specified on a model, such as a page
      # object. When this attribute is provided, the model will have a way to
      # match the URL in the browser with the matcher provided via this
      # attribute.
      def url_matches(pattern = nil)
        url_match_is_empty if pattern.nil?
        url_match_is_empty if pattern.is_a?(String) && pattern.empty?
        @url_match = pattern
      end

      # This allows a test to query for the url match attribute that was set
      # on the model. This does not perform a match or do anything to check
      # if a URL is matching. This simply returns the attribute that was
      # provided for the URL matching.
      def url_match_attribute
        @url_match
      end

      # This is an attribute that can be specified on a model, such as a page
      # object. When this attribute is provided, the model will have a bit of
      # text that provides information about what the title of a browser page
      # should be. This is not checking the title; it's simply providing the
      # text that will be checked against the actual title.
      def title_is(title = nil)
        title_is_empty if title.nil? || title.empty?
        @title = title
      end

      # This allows a test to query for the title attribute that was set on
      # the model. It's important to note that this is not the actual title
      # in the browser, but rather whatever was created on the model.
      def title_attribute
        @title
      end
    end
  end
end
