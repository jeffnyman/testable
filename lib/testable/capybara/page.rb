require "capybara"
require "testable/capybara/node"

module Testable
  class Page < Node
    # The `Page` class wraps an HTML page with an application-specific API.
    # This can be extended to define an API for manipulating the pages of
    # the web application.
    attr_reader :path

    def self.visit
      new.visit
    end

    def initialize(node: Capybara.current_session, path: nil)
      @node = node
      @path = path
    end

    def visit
      @node.visit(path)
      self
    end

    def current?
      @node.current_path == path
    end
  end
end
