require "testable/capybara/dsl"

module Testable
  class Node
    # The Node class represents a wrapped HTML page or fragment. It exposes all
    # methods of the Cogent DSL, making sure that any Capybara API methods
    # are passed to the node instance.
    include DSL

    attr_reader :node

    # A Capybara node is being wrapped in a node instance.
    def initialize(node:)
      @node = node
    end

    # Any Capybara API calls will be sent to the node object.
    def method_missing(name, *args, &block)
      if @node.respond_to?(name)
        @node.send(name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @node.respond_to?(name) || super
    end
  end
end
