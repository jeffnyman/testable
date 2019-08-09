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

    # A call to `url_match_attribute` returns what the value of the
    # `url_matches` attribute is for the given interface. It's important
    # to note that the URL matching mechanism is effectively a regular
    # expression check.
    def url_match_attribute
      value = self.class.url_match_attribute
      return if value.nil?

      value = Regexp.new(value) unless value.is_a?(Regexp)
      value
    end

    # A call to `has_correct_url?`returns true or false if the actual URL
    # found in the browser matches the `url_matches` assertion. This is
    # important to note. It's not using the `url_is` attribute nor the URL
    # displayed in the browser. It's using the `url_matches` attribute.
    def has_correct_url?
      no_url_match_is_possible if url_attribute.nil? && url_match_attribute.nil?
      !(url =~ url_match_attribute).nil?
    end

    alias displayed? has_correct_url?
    alias loaded?    has_correct_url?

    # A call to `title_attribute` returns what the value of the `title_is`
    # attribute is for the given definition. It's important to note that
    # this is not grabbing the title that is displayed in the browser;
    # rather it's the one declared in the interface definition, if any.
    def title_attribute
      self.class.title_attribute
    end

    # A call to `title` returns the actual title of the page that is
    # displayed in the browser.
    def title
      @browser.title
    end

    alias page_title title

    # A call to `has_correct_title?` returns true or false if the actual
    # title of the current page in the browser matches the `title_is`
    # attribute. Notice that this check is done as part of a match rather
    # than a direct check. This allows for regular expressions to be used.
    def has_correct_title?
      no_title_is_provided if title_attribute.nil?
      !title.match(title_attribute).nil?
    end

    # A call to `secure?` returns true if the page is secure and false
    # otherwise. This is a simple check that looks for whether or not the
    # current URL begins with 'https'.
    def secure?
      !url.match(/^https/).nil?
    end

    # A call to `markup` returns all markup on a page. Generally you don't
    # just want the entire markup but rather want to parse the output of
    # the `markup` call.
    def markup
      browser.html
    end

    alias html markup

    # A call to `text` returns all text on a page. Note that this is text
    # that is taken out of the markup context. It is unlikely you will just
    # want the entire text but rather want to parse the output of the
    # `text` call.
    def text
      browser.text
    end

    alias page_text text
  end
end
