# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"

module GreenLog

  # An alternative to `GreenLog::Logger` for older code, which implements the
  # same interface as the built-in Ruby `::Logger`.
  class ClassicLogger

    def initialize(downstream)
      @downstream = downstream
    end

    attr_reader :downstream

    def add(severity, message = :unspecified)
      severity = Integer(severity)
      if block_given?
        raise ArgumentError, "both message and block provided" unless message == :unspecified

        message = yield
      elsif message == :unspecified
        raise ArgumentError, "no message provided"
      end

      entry = Entry.build(severity, normalise_message(message))
      downstream << entry

      true
    end

    def debug(message = :unspecified, &block)
      add(Severity::DEBUG, message, &block)
    end

    def info(message = :unspecified, &block)
      add(Severity::INFO, message, &block)
    end

    def warn(message = :unspecified, &block)
      add(Severity::WARN, message, &block)
    end

    def error(message = :unspecified, &block)
      add(Severity::ERROR, message, &block)
    end

    def fatal(message = :unspecified, &block)
      add(Severity::FATAL, message, &block)
    end

    private

    def normalise_message(message)
      return message if message.is_a?(Exception)
      return message.to_str if message.respond_to?(:to_str)

      message.inspect
    end

  end

end
