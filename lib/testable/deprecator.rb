module Testable
  class Deprecator
    class << self
      # This is used to indicate that certain functionality within Testable
      # has been deprecated and the previous functionality will disappear.
      def deprecate(current, upcoming = nil, known_version = nil)
        if upcoming
          warn(
            "#{current} is being deprecated and should no longer be used. \
            Use #{upcoming} instead."
          )
        else
          warn("#{current} is being deprecated and should no longer be used.")
        end

        warn(
          "#{current} will be removed in Testable #{known_version}."
        ) if known_version
      end

      # This is used to indicate that certain functionality within Testable
      # has been soft deprecated, meaning that some aspect of how the
      # framework is configured has changed and that change will become
      # the new default behavior in a given version.
      def soft_deprecate(current, reason, known_version, upcoming = nil)
        debug("The #{current} method is changing and is now configurable.")
        debug("REASON: #{reason}.")
        debug(
          "Moving forwards into Testable #{known_version}, \
          the default behavior will change."
        )
        debug("It is advised that you change to using #{upcoming}") if upcoming
      end

      private

      def warn(message)
        Testable.logger.warn(message)
      end

      def debug(message)
        Testable.logger.debug(message)
      end
    end
  end
end
