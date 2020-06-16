require "logger"

module Testable
  class Logger
    # Creates a logger instance with a predefined set of configuration
    # options. This logger instance will be available to any portion of
    # tests that are using the framework.
    def create(output = $stdout)
      logger = ::Logger.new(output)
      logger.progname = 'Testable'
      logger.level = :UNKNOWN
      logger.formatter =
        proc do |severity, time, progname, msg|
          "#{time.strftime('%F %T')} - #{severity} - #{progname} - #{msg}\n"
        end

      logger
    end
  end
end
