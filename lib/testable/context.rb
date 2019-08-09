module Testable
  module Context
    # Creates a definition context for actions and establishes the context
    # for execution. Given an interface definition for a page like this:
    #
    #    class TestPage
    #      include Testable
    #
    #      url_is "http://localhost:9292"
    #    end
    #
    # You can do the following:
    #
    #    on_visit(TestPage)
    def on_visit(definition, &block)
      create_active(definition)
      @active.visit
      verify_page(@active)
      call_block(&block)
    end

    # Creates a definition context for actions. If an existing context
    # exists, that context will be re-used. You can use this simply to keep
    # the context for a script clear. For example, say you have the following
    # interface definitions for pages:
    #
    #    class Home
    #      include Testable
    #      url_is "http://localhost:9292"
    #    end
    #
    #    class Navigation
    #      include Testable
    #    end
    #
    # You could then do this:
    #
    #    on_visit(Home)
    #    on(Navigation)
    #
    # The Home definition needs the url_is attribute in order for the on_view
    # factory to work. But Navigation does not because the `on` method is not
    # attempting to visit, simply to reference.
    def on(definition, &block)
      create_active(definition)
      call_block(&block)
    end

    private

    # This method is used to provide a means for checking if a page has been
    # navigated to correctly as part of a context. This is useful because
    # the context signature should remain highly readable, and checks for
    # whether a given page has been reached would make the context definition
    # look sloppy.
    def verify_page(context)
      return if context.url_match_attribute.nil?
      return if context.has_correct_url?

      raise Testable::Errors::PageURLFromFactoryNotVerified
    end

    def create_active(definition)
      @active = definition.new unless @active.is_a?(definition)
    end

    def call_block(&block)
      yield @active if block
      @active
    end
  end
end
