require "testable/version"
require "testable/page"
require "testable/attribute"

require "watir"
require "capybara"
require "webdrivers"

module Testable
  def self.included(caller)
    caller.extend Testable::Pages::Attribute
    caller.__send__ :include, Testable::Pages
  end

  class << self
    def watir_api
      browser.methods - Object.public_methods -
        Watir::Container.instance_methods
    end

    def selenium_api
      browser.driver.methods - Object.public_methods
    end

    # This accessor is needed so that Cogent itself can provide a browser
    # reference to indicate connection to WebDriver. This is a class-level
    # access to the browser.
    attr_accessor :browser

    def set_browser(app = :chrome, *args)
      @browser = Watir::Browser.new(app, *args)
      Testable.browser = @browser
    end

    alias start_browser set_browser

    def quit_browser
      @browser.quit
    end

    def api
      methods - Object.public_methods
    end
  end
end
