# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"

module GreenLog

  # Represents a structured log entry.
  class Logger

    def initialize(downstream, level: Severity::DEBUG)
      @downstream = downstream
      self.level = level
    end

    attr_reader :downstream
    attr_reader :level

    def level=(severity)
      @level = Severity.resolve(severity)
    end

    def log(severity, *rest, &block)
      severity = Severity.resolve(severity)
      return false if level > severity

      entry = Entry.build(severity, *rest, &block)
      downstream << entry
      true
    end

    def debug(*args, &block)
      log(Severity::DEBUG, *args, &block)
    end

    def info(*args, &block)
      log(Severity::INFO, *args, &block)
    end

    def warn(*args, &block)
      log(Severity::WARN, *args, &block)
    end

    def error(*args, &block)
      log(Severity::ERROR, *args, &block)
    end

    def fatal(*args, &block)
      log(Severity::FATAL, *args, &block)
    end

    def with_context(context)
      with_downstream Contextualizer.new(downstream, context)
    end

    def with_downstream(new_downstream)
      self.class.new(new_downstream, level: level)
    end

  end

end
