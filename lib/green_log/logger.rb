# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"

module GreenLog

  # Represents a structured log entry.
  class Logger

    def initialize(downstream)
      @downstream = downstream
      @level = Severity::DEBUG
    end

    attr_reader :downstream
    attr_reader :level

    def level=(severity)
      @level = Severity.resolve(severity)
    end

    def log(severity, message)
      severity = Severity.resolve(severity)
      return false if level > severity

      entry = Entry.with(severity: severity, message: message)
      downstream << entry
    end

    def debug(*args)
      log(Severity::DEBUG, *args)
    end

    def info(*args)
      log(Severity::INFO, *args)
    end

    def warn(*args)
      log(Severity::WARN, *args)
    end

    def error(*args)
      log(Severity::ERROR, *args)
    end

    def fatal(*args)
      log(Severity::FATAL, *args)
    end

  end

end
