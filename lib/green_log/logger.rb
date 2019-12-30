# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"
require "green_log/severity_filter"
require "green_log/severity_threshold_support"

module GreenLog

  # Represents a structured log entry.
  class Logger

    def initialize(downstream)
      @downstream = downstream
    end

    attr_reader :downstream

    include SeverityThresholdSupport

    def log(severity, *rest, &block)
      severity = Severity.resolve(severity)
      return false if severity < severity_threshold

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

    # Add a middleware in front of the downstream handler.
    # Return a new Logger with the expanded handler-stack.
    def with_middleware
      self.class.new(yield(downstream))
    end

    # Add a middleware that adds context.
    # Return a new Logger with the expanded handler-stack.
    def with_context(context)
      with_middleware do |current_downstream|
        Contextualizer.new(current_downstream, context)
      end
    end

    # Add a middleware that filters by severity.
    # Return a new Logger with the expanded handler-stack.
    def with_severity_threshold(threshold)
      with_middleware do |downstream|
        SeverityFilter.new(downstream, threshold: threshold)
      end
    end

  end

end
