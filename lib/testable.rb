require "testable/version"
require "testable/page"
require "testable/ready"
require "testable/logger"
require "testable/context"
require "testable/element"
require "testable/locator"
require "testable/attribute"
require "testable/deprecator"

require "testable/capybara/page"

require "testable/extensions/core_ruby"
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

  def initialize(browser = nil, &block)
    @browser = Testable.browser unless Testable.browser.nil?
    @browser = browser if Testable.browser.nil?
    begin_with if respond_to?(:begin_with)
    instance_eval(&block) if block
  end

  # This accessor is needed so that internal API calls, like `markup` or
  # `text`, have access to the browser instance. This is also necessary
  # in order for element handling to be called appropriately on the a
  # valid browser instance. This is an instance-level access to whatever
  # browser Testable is using.
  attr_accessor :browser

  class << self
    # Provides a means to allow a configure block on Testable. This allows you
    # to setup Testable, as such:
    #
    #  Testable.configure do |config|
    #    config.driver_timeout = 5
    #    config.wire_level_logging = :info
    #    config.log_level = :debug
    #  end
    def configure
      yield self
    end

    # Watir provides a default timeout of 30 seconds. This allows you to change
    # that in the Testable context. For example:
    #
    #   Testable.driver_timeout = 5
    #
    # This would equivalent to doing this:
    #
    #    Watir.default_timeout = 5
    def driver_timeout=(value)
      Watir.default_timeout = value
    end

    # The Testable logger object. To log messages:
    #
    #   Testable.logger.info('Some information.')
    #   Testable.logger.debug('Some diagnostics')
    #
    # To alter or check the current logging level, you can call `.log_level=`
    # or `.log_level`. By default the logger will output all messages to the
    # standard output ($stdout) but it can be altered to log to a file or to
    # another IO location by calling `.log_path=`.
    def logger
      @logger ||= Testable::Logger.new.create
    end

    # To enable logging, do this:
    #
    #   Testable.log_level = :DEBUG
    #   Testable.log_level = 'DEBUG'
    #   Testable.log_level = 0
    #
    # This can accept any of a Symbol / String / Integer as an input
    # To disable all logging, which is the case by default, do this:
    #
    #   Testable.log_level = :UNKNOWN
    def log_level=(value)
      logger.level = value
    end

    # To query what level is being logged, do this:
    #
    #   Testable.log_level
    #
    # The logging level will be UNKNOWN by default.
    def log_level
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][logger.level]
    end

    # The writer method allows you to configure where you want the output of
    # the Testable logs to go, with the default being standard output. Here
    # is how you could change this to a specific file:
    #
    #   Testable.log_path = 'testable.log'
    def log_path=(logdev)
      logger.reopen(logdev)
    end

    # The wire logger provides logging from Watir, which is very similar to the
    # logging provided by Selenium::WebDriver::Logger. The default level is set
    # to warn. This means you will see any deprecation notices as well as any
    # warning messages. To see details on each element interaction the level
    # can be set to info. To see details on what Watir is doing when it takes a
    # selector hash and converts it into XPath, the level can be set to debug.
    # If you want to ignore specific warnings that are appearing during test
    # execution:
    #
    # Watir.logger.ignore :warning_name
    #
    # If you want to ignore all deprecation warnings in your tests:
    #
    # Watir.logger.ignore :deprecations
    #
    # To have the wire logger generate output to a file:
    #
    # Watir.logger.output = "wire.log"

    def wire_path=(logdev)
      Watir.logger.reopen(logdev)
    end

    def wire_level_logging=(value)
      Watir.logger.level = value
    end

    def wire_level_logging
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][Watir.logger.level]
    end

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
