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

    def add(severity, message = nil)
      severity = Integer(severity)
      raise ArgumentError, "both message and block provided" if !message.nil? && block_given?

      message = yield if block_given?
      raise ArgumentError, "no message provided" if message.nil?

      message = message.to_str
      entry = Entry.build(severity, message)
      downstream << entry

      true
    end

    def debug(message = nil, &block)
      add(Severity::DEBUG, message, &block)
    end

    def info(message = nil, &block)
      add(Severity::INFO, message, &block)
    end

    def warn(message = nil, &block)
      add(Severity::WARN, message, &block)
    end

    def error(message = nil, &block)
      add(Severity::ERROR, message, &block)
    end

    def fatal(message = nil, &block)
      add(Severity::FATAL, message, &block)
    end

  end

end
