require "testable/situation"

module Testable
  module Pages
    include Situation

    # The `visit` method provides navigation to a specific page by passing
    # in the URL. If no URL is passed in, this method will attempt to use
    # the `url_is` attribute from the interface it is being called on.
    def visit(url = nil)
      no_url_provided if url.nil? && url_attribute.nil?
      @browser.goto(url) unless url.nil?
      @browser.goto(url_attribute) if url.nil?
    end

    alias view        visit
    alias navigate_to visit
    alias goto        visit
    alias perform     visit

    # A call to `url_attribute` returns what the value of the `url_is`
    # attribute is for the given interface. It's important to note that
    # this is not grabbing the URL that is displayed in the browser;
    # rather it's the one declared in the interface definition, if any.
    def url_attribute
      self.class.url_attribute
    end

    # A call to `url` returns the actual URL of the page that is displayed
    # in the browser.
    def url
      @browser.url
    end

    alias page_url    url
    alias current_url url
  end
end
