module Testable
  module Pages
    # A call to `url_attribute` returns what the value of the `url_is`
    # attribute is for the given interface. It's important to note that
    # this is not grabbing the URL that is displayed in the browser;
    # rather it's the one declared in the interface definition, if any.
    def url_attribute
      self.class.url_attribute
    end
  end
end
