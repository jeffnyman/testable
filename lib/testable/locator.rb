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
      def access_element(element, locators, _qualifiers)
        if element == "element".to_sym
          @browser.element(locators).to_subtype
        else
          @browser.__send__(element, locators)
        end
      rescue Watir::Exception::UnknownObjectException
        return false if caller_locations.any? do |str|
          str.to_s.match?("ready_validations_pass?")
        end

        raise
      end
    end
  end
end
