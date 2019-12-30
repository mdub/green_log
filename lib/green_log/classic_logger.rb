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

    def add(severity, message)
      severity = Integer(severity)
      message = message.to_str
      entry = Entry.build(severity, message)
      downstream << entry

      true
    end

    def debug(message)
      add(Severity::DEBUG, message)
    end

    def info(message)
      add(Severity::INFO, message)
    end

    def warn(message)
      add(Severity::WARN, message)
    end

    def error(message)
      add(Severity::ERROR, message)
    end

    def fatal(message)
      add(Severity::FATAL, message)
    end

  end

end
