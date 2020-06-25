module Testable
  module Pages
    module Region
      # Allows for a "has_one" method to be declared on a model, like a page
      # object to specify that the model has a region associated with it. In
      # this case, that would be a single region that can be located by a
      # reference to a specific class (which is also a model) and, relative
      # to that model, is within some specific means of identification.
      # rubocop:disable Naming/PredicateName
      def has_one(identifier, **context, &block)
        within = context[:in] || context[:within]
        region_class = context[:class] || context[:region_class]
        define_region_accessor(identifier, within: within, region_class: region_class, &block)
      end

      # Allows for a "has_many" method to be declared on a model, like a poage
      # object to specify that the model was a certain region associated with
      # it, but where that region occurs more than once.
      def has_many(identifier, **context, &block)
        region_class = context[:class] || context[:region_class]
        collection_class = context[:through] || context[:collection_class]
        each = context[:each] || raise(ArgumentError, 'the "has_many" method requires an "each" param')
        within = context[:in] || context[:within]
        define_region_accessor(
          identifier,
          within: within,
          each: each,
          region_class: region_class,
          collection_class: collection_class,
          &block
        )
        define_finder_method(identifier)
      end
      # rubocop:enable Naming/PredicateName

      private

      # Defines an accessor method for an region.
      # ..........................
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/ParameterLists
      # rubocop:disable Metrics/BlockLength
      # rubocop:disable Metrics/BlockNesting
      def define_region_accessor(identifier, within: nil, each: nil, collection_class: nil, region_class: nil, &block)
        include(Module.new do
          define_method(identifier) do
            # The class path is what essentially determines the model to
            # reference that the region is a part of. However, it is possible
            # to define an inline region, which would effectively make the
            # class anonymous, and thus not having an actual name. Thus is it
            # necessary to provide a stand-in name for those cases.
            class_path = self.class.name ? self.class.name.split('::') : ['TestableRegion']

            # Namespacing is needed in cases where there are nested classes.
            # It's important to get the full namespace of any classes that are
            # said to reference the region.
            namespace =
              if class_path.size > 1
                class_path.pop
                Object.const_get(class_path.join('::'))
              elsif class_path.size == 1
                self.class
              else
                raise Testable::Errors::RegionNamespaceError, "Cannot understand namespace from #{class_path}"
              end

            # A copy of the passed-in region class is necessary because the
            # `region_class` is declared outside of this defined function.
            # And the function could change that class. Thus a reference is
            # needed to the original `region_class` but also allowing for that
            # class to be changed.
            region_single_class = region_class

            unless region_single_class
              if block_given?
                region_single_class = Class.new
                region_single_class.class_eval { include(Testable) }
                region_single_class.class_eval(&block)
              else
                singular_klass = identifier.to_s.split('_').map(&:capitalize).join

                # rubocop:disable Style/MissingElse
                if each
                  collection_class_name = "#{singular_klass}Region"
                  singular_klass = singular_klass.sub(/s\z/, '')
                end
                # rubocop:enable Style/MissingElse

                singular_klass << 'Region'
                region_single_class = namespace.const_get(singular_klass)
              end
            end

            # The scope is used to provide a reference to the element that
            # is said to act as a container for the region.
            scope =
              case within
                when Proc
                  instance_exec(&within)
                when Hash
                  region_element.element(within)
                else
                  region_element
              end

            if each
              # The `elements` will be a `Watir::HTMLElementCollection`.
              elements = (scope.exists? ? scope.elements(each) : [])

              if collection_class_name && namespace.const_defined?(collection_class_name)
                region_collection_class = namespace.const_get(collection_class_name)
              elsif collection_class
                region_collection_class = collection_class
              else
                return elements.map { |element| region_single_class.new(@browser, element, self) }
              end

              region_collection_class.class_eval do
                include Enumerable

                attr_reader :region_collection

                define_method(:initialize) do |browser, region_element, region_elements|
                  super(browser, region_element, self)

                  @region_collection =
                    if region_elements.all? { |element| element.is_a?(Watir::Element) }
                      region_elements.map { |element| region_single_class.new(browser, element, self) }
                    else
                      region_elements
                    end
                end

                def each(&block)
                  region_collection.each(&block)
                end
              end

              region_collection_class.new(@browser, scope, elements)
            else
              region_single_class.new(@browser, scope, self)
            end
          end
        end)
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/ParameterLists
      # rubocop:enable Metrics/BlockLength
      # rubocop:enable Metrics/BlockNesting

      def define_finder_method(identifier)
        finder_method_name = identifier.to_s.sub(/s\z/, '')

        include(Module.new do
          define_method(finder_method_name) do |**opts|
            __send__(region_name).find do |entity|
              opts.all? do |key, value|
                entity.__send__(key) == value
              end
            end || raise(Testable::Errors::RegionFinderError, "No #{finder_method_name} matching: #{opts}.")
          end
        end)
      end
    end
  end
end
