require "watir"

module Testable
  module_function

  NATIVE_QUALIFIERS = %i[visible].freeze
  private_constant :NATIVE_QUALIFIERS

  # This predicate method returns all of the elements that can be recognized
  # by Watir.
  def elements?
    @elements
  end

  # This predicate method checks if a given element is in the list of known
  # elements that Watir knows how to interact with.
  def recognizes?(method)
    @elements.include? method.to_sym
  end

  # Provides a list of all elements that Watir knows how to work with. This
  # is generated from the Watir container itself so the list should always
  # be up to date.
  def elements
    @elements ||= Watir::Container.instance_methods unless @elements
  end

  module Pages
    module Element
      # This iterator goes through the Watir container methods and
      # provides a method for each so that Watir-based element names
      # cane be defined on an interface definition, as part of an
      # element definition.
      Testable.elements.each do |element|
        define_method(element) do |*signature, &block|
          identifier, signature = parse_signature(signature)
          context = context_from_signature(signature, &block)
          define_element_accessor(identifier, signature, element, &context)
        end
      end

      private

      # A "signature" consists of a full element definition. For example:
      #
      #    text_field :username, id: 'username'
      #
      # The signature of this element definition is:
      #
      #    [:username, {:id=>"username"}]
      #
      # This is the identifier of the element (`username`) and the locator
      # provided for it. This method separates out the identifier and the
      # locator.
      def parse_signature(signature)
        [signature.shift, signature.shift]
      end

      # Returns the block or proc that serves as a context for an element
      # definition. Consider the following element definitions:
      #
      #    ul   :facts, id: 'fact-list'
      #    span :fact, -> { facts.span(class: 'site-item')}
      #
      # Here the second element definition provides a proc that contains a
      # context for another element definition. That leads to the following
      # construction being sent to the browser:
      #
      #    @browser.ul(id: 'fact-list').span(class: 'site-item')
      def context_from_signature(*signature, &block)
        if block_given?
          block
        else
          context = signature.shift
          context.is_a?(Proc) && signature.empty? ? context : nil
        end
      end

      # This method provides the means to get the aspects of an accessor
      # signature. The "aspects" refer to the locator information and any
      # qualifier information that was provided along with the locator.
      # This is important because the qualifier is not used to locate an
      # element but rather to put conditions on how the state of the
      # element is checked as it is being looked for.
      #
      # Note that "qualifiers" here refers to Watir boolean methods.
      def accessor_aspects(element, *signature)
        identifier = signature.shift
        locator_args = {}
        qualifier_args = {}
        gather_aspects(identifier, element, locator_args, qualifier_args)
        [locator_args, qualifier_args]
      end

      # This method is used to separate the two aspects of an accessor --
      # the locators and the qualifiers. Part of this process involves
      # querying the Watir driver library to determine what qualifiers
      # it handles natively. Consider the following:
      #
      #    select_list :accounts, id: 'accounts', selected: 'Select Option'
      #
      # Given that, this method will return with the following:
      #
      #    locator_args: {:id=>"accounts"}
      #    qualifier_args: {:selected=>"Select Option"}
      #
      # Consider this:
      #
      #    p :login_form, id: 'open', index: 0, visible: true
      #
      # Given that, this method will return with the following:
      #
      #    locator_args: {:id=>"open", :index=>0, :visible=>true}
      #    qualifier_args: {}
      #
      # Notice that the `visible` qualifier is part of the locator arguments
      # as opposed to being a qualifier argument, like `selected` was in the
      # previous example. This is because Watir 6.x handles the `visible`
      # qualifier natively. "Handling natively" means that when a qualifier
      # is part of the locator, Watir knows how to intrpret the qualifier
      # as a condition on the element, not as a way to locate the element.
      def gather_aspects(identifier, element, locator_args, qualifier_args)
        identifier.each_with_index do |hashes, index|
          next if hashes.nil? || hashes.is_a?(Proc)

          hashes.each do |k, v|
            methods = Watir.element_class_for(element).instance_methods
            if methods.include?(:"#{k}?") && !NATIVE_QUALIFIERS.include?(k)
              qualifier_args[k] = identifier[index][k]
            else
              locator_args[k] = v
            end
          end
        end
        [locator_args, qualifier_args]
      end

      # Defines an accessor method for an element that allows the "friendly
      # name" (identifier) of the element to be proxied to a Watir element
      # object that corresponds to the element type. When this identifier
      # is referenced, it generates an accessor method for that element
      # in the browser. Consider this element definition defined on a class
      # with an instance of `page`:
      #
      #    text_field :username, id: 'username'
      #
      # This allows:
      #
      #    page.username.set 'tester'
      #
      # So any element identifier can be called as if it were a method on
      # the interface (class) on which it is defined. Because the method
      # is proxied to Watir, you can use the full Watir API by calling
      # methods (like `set`, `click`, etc) on the element identifier.
      #
      # It is also possible to have an element definition like this:
      #
      #    text_field :password
      #
      # This would allow access like this:
      #
      #    page.username(id: 'username').set 'tester'
      #
      # This approach would lead to the *values variable having an array
      # like this: [{:id => 'username'}].
      #
      # A third approach would be to utilize one element definition within
      # the context of another. Consider the following element definitions:
      #
      #    article :practice, id: 'practice'
      #
      #    a :page_link do |text|
      #      practice.a(text: text)
      #    end
      #
      # This would allow access like this:
      #
      #    page.page_link('Drag and Drop').click
      #
      # This approach would lead to the *values variable having an array
      # like this: ["Drag and Drop"].
      def define_element_accessor(identifier, *signature, element, &block)
        locators, qualifiers = accessor_aspects(element, signature)
        define_method(identifier.to_s) do |*values|
          if block_given?
            instance_exec(*values, &block)
          else
            locators = values[0] if locators.empty?
            access_element(element, locators, qualifiers)
          end
        end
      end
    end
  end
end
