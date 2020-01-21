# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"
require "green_log/severity"
require "green_log/severity_threshold_support"

module GreenLog

  # An alternative to `GreenLog::Logger` for older code, which implements the
  # same interface as the built-in Ruby `::Logger`.
  class ClassicLogger

    def initialize(downstream)
      @downstream = downstream
    end

    attr_reader :downstream

    include SeverityThresholdSupport

    def add(severity, message = :unspecified, &block)
      severity = Integer(severity)
      return if severity < severity_threshold

      entry = Entry.build(severity, resolve_message(message, &block))

      downstream << entry

      true
    end

    Severity::NAMES.each_with_index do |name, severity|

      define_method(name.downcase) do |message = :unspecified, &block|
        add(severity, message, &block)
      end

      define_method("#{name.downcase}?") do
        severity >= severity_threshold
      end

    end

    private

    def resolve_message(message, &block)
      normalise_message(extract_message(message, &block))
    end

    def extract_message(message, &block)
      if block
        raise ArgumentError, "both message and block provided" unless message == :unspecified

        return block.call
      end
      raise ArgumentError, "no message provided" if message == :unspecified

      message
    end

    def normalise_message(message)
      return message if message.is_a?(Exception)
      return message.to_str if message.respond_to?(:to_str)

      message.inspect
    end

  end

  # :rubocop:disable: Style/Documentation
  class Logger

    def to_classic_logger
      GreenLog::ClassicLogger.new(downstream)
    end

  end

end
