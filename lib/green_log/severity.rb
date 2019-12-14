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

    class << self

      NAMES = %w[DEBUG INFO WARN ERROR FATAL].freeze

      def name(severity)
        NAMES[severity]
      end

      def resolve(arg)
        value = case arg
                when Integer
                  arg
                when Symbol, String
                  NAMES.index(arg.to_s.upcase)
                end
        return value if value && (DEBUG..FATAL).cover?(value)

        raise ArgumentError, "invalid severity: #{arg.inspect}"
      end

    end

  end

end
