# frozen_string_literal: true

module GreenLog

  # Levels of severity.
  module Severity

    # Low-level information, mostly for developers.
    DEBUG = 0
    # Generic (useful) information about system operation.
    INFO = 1
    # A warning.
    WARN = 2
    # A handleable error condition.
    ERROR = 3
    # An unhandleable error that results in a program crash.
    FATAL = 4

    NAMES = %i[DEBUG INFO WARN ERROR FATAL].freeze

    class << self

      def name(severity)
        NAMES[severity]
      end

      def resolve(arg)
        value = _resolve(arg)
        return value if value && (DEBUG..FATAL).cover?(value)

        raise ArgumentError, "invalid severity: #{arg.inspect}"
      end

      private

      def _resolve(arg)
        case arg
        when Integer
          arg
        when Symbol, String
          NAMES.index(arg.to_sym.upcase)
        end
      end

    end

  end

end
