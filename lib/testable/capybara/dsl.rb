module Testable
  module DSL
    # The DSL module is mixed into the Node class to provide the DSL for
    # defining elements and components.
    def self.included(caller)
      caller.extend(ClassMethods)
    end

    module ClassMethods
      # The ClassMethods provide a set of macro-like methods for wrapping
      # HTML fragments in Node objects.

      # Defines an element that wraps an HTML fragment.
      def element(name, selector, options = {})
        define_method(name.to_s) do
          Node.new(node: @node.find(selector, options))
        end

        define_helpers(name, selector)
      end

      # Defines a collection of elements that wrap HTML fragments.
      def elements(name, selector, options = {})
        options = { minimum: 1 }.merge(options)

        define_method(name.to_s) do
          @node.all(selector, options).map do |node|
            Node.new(node: node)
          end
        end

        define_helpers(name, selector)
      end

      # Defines a component that wraps an HTML fragment.
      def component(name, klass, selector, options = {})
        unless klass < Node
          raise ArgumentError, 'Must be given a subclass of Node'
        end

        define_method(name.to_s) do
          klass.new(node: @node.find(selector, options))
        end

        define_helpers(name, selector)
      end

      # Defines a collection of components that wrap HTML fragments.
      def components(name, klass, selector, options = {})
        unless klass < Node
          raise ArgumentError, 'Must be given a subclass of Node'
        end

        options = { minimum: 1 }.merge(options)

        define_method(name.to_s) do
          @node.all(selector, options).map do |node|
            klass.new(node: node)
          end
        end

        define_helpers(name, selector)
      end

      private

      def define_helpers(name, selector)
        define_existence_predicates(name, selector)
      end

      def define_existence_predicates(name, selector)
        define_method("has_#{name}?") do
          @node.has_selector?(selector)
        end

        define_method("has_no_#{name}?") do
          @node.has_no_selector?(selector)
        end
      end
    end
  end
end
