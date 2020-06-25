module Testable
  module Element
    module Locator
      private

      # This method is what actually calls the browser instance to find
      # an element. If there is an element definition like this:
      #
      #    text_field :username, id: 'username'
      #
      # This will become the following:
      #
      #    browser.text_field(id: 'username')
      #
      # Note that the `to_subtype` method is called, which allows for the
      # generic `element` to be expressed as the type of element, as opposed
      # to `text_field` or `select_list`. For example, an `element` may be
      # defined like this:
      #
      #    element :enable, id: 'enableForm'
      #
      # Which means it would look like this:
      #
      #    Watir::HTMLElement:0x1c8c9 selector={:id=>"enableForm"}
      #
      # Whereas getting the subtype would give you:
      #
      #    Watir::CheckBox:0x12f8b elector={element: (webdriver element)}
      #
      # Which is what you would get if the element definition were this:
      #
      #    checkbox :enable, id: 'enableForm'
      #
      # Using the subtype does get tricky for scripts that require the
      # built-in sychronization aspects and wait states of Watir.
      #
      # The approach being used in this method is necessary to allow actions
      # like `set`, which are not available on `element`, even though other
      # actions, like `click`, are. But if you use `element` for your element
      # definitions, and your script requires a series of actions where elements
      # may be delayed in appearing, you'll get an "unable to locate element"
      # message, along with a Watir::Exception::UnknownObjectException.
      #
      # A check is made if an UnknownObjectException occurs due to a ready
      # validation. That's necessary because a ready validation has to find
      # an element in order to determine the ready state, but that element
      # might not be present.

      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      def access_element(element, locators, qualifiers)
        if qualifiers.empty?
          if element == "element".to_sym
            @browser.element(locators).to_subtype
          else
            region_element.__send__(element, locators)
          end
        else
          # If the qualifiers are not empty, then that means the framework
          # has to consider a given set of elements so that it can check
          # the qualifier against them.
          plural = Testable.plural?(element)
          element = Testable.pluralize(element) unless plural

          elements = region_element.__send__(element, locators)

          # Consider the following element definition:
          #
          # select_list :car_make, name: 'car', selected: 'Audi', enabled: true
          #
          # In this case, the qualifiers will be `selected` (with a value of)
          # "Audi") and `enabled` (with a value of true. The arity of the
          # `selected` method would be 1 while the arity of the `enabled`
          # method would be 0.
          qualifiers.each do |qualifier, value|
            elements.to_a.select! do |ele|
              if ele.public_method(:"#{qualifier}?").arity.zero?
                ele.__send__(:"#{qualifier}?") == value
              else
                ele.__send__(:"#{qualifier}?", value)
              end
            end
          end

          # If the locator passed in was plural, then any elements matching
          # the locator and qualifier have to be returned. Otherwise, it will
          # just be the first item of the elements found.
          plural ? elements : elements.first
        end
      rescue Watir::Exception::UnknownObjectException
        return false if caller_locations.any? do |str|
          str.to_s.match?("ready_validations_pass?")
        end

        raise
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/MethodLength
    end
  end
end
