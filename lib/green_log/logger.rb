# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"
require "green_log/severity_filter"
require "green_log/severity_threshold_support"
require "green_log/null_writer"
require "green_log/simple_writer"

module GreenLog

  # Log entry generator.
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
    def with_context(static_context = nil, &context_generator)
      with_middleware do |current_downstream|
        downstream = current_downstream
        downstream = Contextualizer.new(downstream) { static_context } unless static_context.nil?
        downstream = Contextualizer.new(downstream, &context_generator) unless context_generator.nil?
        downstream
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
        format = resolve_format(format)
        downstream = format.new(dest)
        downstream = SeverityFilter.new(downstream, threshold: severity_threshold) if severity_threshold
        new(downstream)
      end

      def resolve_format(format)
        return format if format.is_a?(Class)

        format = format.to_s if format.is_a?(Symbol)
        GreenLog.const_get("#{format.capitalize}Writer")
      end

      # Return a null-object Logger.
      def null
        new(NullWriter.new)
      end

    end

  end

end
