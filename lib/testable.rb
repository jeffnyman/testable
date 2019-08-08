require "testable/version"

require "watir"
require "capybara"
require "webdrivers"

module Testable
  class << self
    def watir_api
      browser.methods - Object.public_methods -
        Watir::Container.instance_methods
    end

    def selenium_api
      browser.driver.methods - Object.public_methods
    end

    attr_accessor :browser

    def api
      methods - Object.public_methods
    end
  end
end
