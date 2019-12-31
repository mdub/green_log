# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"
require "green_log/severity_filter"
require "green_log/severity_threshold_support"
require "green_log/simple_writer"

module GreenLog

  # Represents a structured log entry.
  class Logger

    def initialize(downstream)
      @downstream = downstream
    end

    attr_reader :downstream

    include SeverityThresholdSupport

    # Generate a log entry.
    # Arguments may include:
    #   - a message string
    #   - arbitrary data
    #   - an exception
    def log(severity, *rest, &block)
      severity = Severity.resolve(severity)
      return false if severity < severity_threshold

      entry = Entry.build(severity, *rest, &block)
      downstream << entry
      true
    end

    Severity::NAMES.each_with_index do |name, severity|

      define_method(name.downcase) do |*args, &block|
        log(severity, *args, &block)
      end

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

    class << self

      # Build a Logger.
      def build(dest: $stdout, format: SimpleWriter, severity_threshold: nil)
        downstream = format.new(dest)
        downstream = SeverityFilter.new(downstream, threshold: severity_threshold) if severity_threshold
        new(downstream)
      end

    end

  end

end
