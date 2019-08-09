require "testable/version"
require "testable/page"
require "testable/ready"
require "testable/context"
require "testable/element"
require "testable/locator"
require "testable/attribute"

require "testable/extensions/data_setter"
require "testable/extensions/dom_observer"

require "watir"
require "capybara"
require "webdrivers"

module Testable
  def self.included(caller)
    caller.extend Testable::Pages::Attribute
    caller.extend Testable::Pages::Element
    caller.__send__ :include, Testable::Ready
    caller.__send__ :include, Testable::Pages
    caller.__send__ :include, Testable::Element::Locator
    caller.__send__ :include, Testable::DataSetter
  end

  def initialize(browser = nil)
    @browser = Testable.browser unless Testable.browser.nil?
    @browser = browser if Testable.browser.nil?
    begin_with if respond_to?(:begin_with)
  end

  # This accessor is needed so that internal API calls, like `markup` or
  # `text`, have access to the browser instance. This is also necessary
  # in order for element handling to be called appropriately on the a
  # valid browser instance. This is an instance-level access to whatever
  # browser Testable is using.
  attr_accessor :browser

  class << self
    def watir_api
      browser.methods - Object.public_methods -
        Watir::Container.instance_methods
    end

    def selenium_api
      browser.driver.methods - Object.public_methods
    end

    # This accessor is needed so that Testable itself can provide a browser
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
