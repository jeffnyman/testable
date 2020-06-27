require "testable/version"
require "testable/page"
require "testable/ready"
require "testable/region"
require "testable/logger"
require "testable/context"
require "testable/element"
require "testable/locator"
require "testable/attribute"
require "testable/deprecator"

require "testable/extensions/core_ruby"
require "testable/extensions/data_setter"
require "testable/extensions/dom_observer"

require "watir"

module Testable
  # This is the core method of Testable which makes the various components
  # of the framework available to tests.
  def self.included(caller)
    caller.extend Testable::Pages::Attribute
    caller.extend Testable::Pages::Element
    caller.extend Testable::Pages::Region
    caller.__send__ :include, Testable::Ready
    caller.__send__ :include, Testable::Pages
    caller.__send__ :include, Testable::Element::Locator
    caller.__send__ :include, Testable::DataSetter
  end

  # Initialization is used to establish a browser instance within the
  # context of the framework. The logic here requires determining under
  # what condition a browser instance may have been set.
  def initialize(browser = nil, region_element = nil, parent = nil, &block)
    @browser = Testable.browser unless Testable.browser.nil?
    @browser = browser if Testable.browser.nil?
    @region_element = region_element || Testable.browser
    @parent = parent
    definition_setup
    instance_eval(&block) if block
  end

  # This method is used to setup any definitions provided as part of the
  # executable of Testable. This generally means any page definitions that
  # include Testable.
  def definition_setup
    begin_with if respond_to?(:begin_with)
    initialize_page if respond_to?(:initialize_page)
    initialize_region if respond_to?(:initialize_region)
    initialize_regions
  end

  # This method is used to interate through any definitions that provide
  # an "initialize_region" method. What happens here is essentially that
  # new polymorphic modules are created based on classes. This is what
  # allows a region to be part of a page definition, the latter of which
  # is nothing more than a standard Ruby class.
  def initialize_regions
    @initialized_regions ||= []

    # The goal here is get all included and extended modules.
    modules = self.class.included_modules + (class << self; self end).included_modules
    modules.uniq!

    # Then each of those modules can be initialized.
    modules.each do |m|
      # First a check is made the that constructor is defined and that it has
      # not been called before.
      next if @initialized_regions.include?(m) || !m.instance_methods.include?(:initialize_region)

      m.instance_method(:initialize_region).bind(self).call

      @initialized_regions << m
    end
  end

  # This accessor is needed so that internal API calls, like `markup` or
  # `text`, have access to the browser instance. This is also necessary
  # in order for element handling to be called appropriately on the a
  # valid browser instance. This is an instance-level access to whatever
  # browser Testable is using.
  attr_accessor :browser

  # This accessor is needed so that the region_element is recognized as
  # part of the overall execution context of Testable.
  attr_reader :region_element

  # This accessor is needed so that the parent of a region is recognized as
  # part of the overall execution context of Testable.
  attr_reader :parent

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

    # Path for the logger to use.
    def wire_path=(logdev)
      Watir.logger.reopen(logdev)
    end

    # Level of logging.
    def wire_level_logging=(value)
      Watir.logger.level = value
    end

    # Report the current logging level.
    def wire_level_logging
      %i[DEBUG INFO WARN ERROR FATAL UNKNOWN][Watir.logger.level]
    end

    # Returns information about the API that Watir exposes. This does not
    # include Selenium elements, which Watir is wrapping.
    def watir_api
      browser.methods - Object.public_methods -
        Watir::Container.instance_methods
    end

    # Returns information about the API that is specific to Selenium.
    def selenium_api
      browser.driver.methods - Object.public_methods
    end

    # This accessor is needed so that Testable itself can provide a browser
    # reference to indicate connection to WebDriver. This is a class-level
    # access to the browser.
    attr_accessor :browser

    # This sets the browser instance so that Testable is aware of what that
    # instance is. This is how a test, using the Testable framework, will
    # be able to know which browser to communicate with.
    def set_browser(app = :chrome, *args)
      @browser = Watir::Browser.new(app, *args)
      Testable.browser = @browser
    end

    alias start_browser set_browser

    # Generates a quit event on the browser instance. This is passed through
    # to Watir which will ultimately delegate browser handling to Selenium
    # and thus WebDriver.
    def quit_browser
      @browser.quit
    end

    # This provides the API that is defined by Testable when you have a
    # working model, such as a page object.
    def api
      methods - Object.public_methods
    end
  end
end
