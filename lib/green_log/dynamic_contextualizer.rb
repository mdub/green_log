# frozen_string_literal: true

require "green_log/severity_threshold_support"

module GreenLog

  # Log middleware that dynamically adds context.
  class DynamicContextualizer

    def initialize(downstream, &block)
      @downstream = downstream
      @context_generator = block
    end

    attr_reader :downstream
    attr_reader :context_generator

    def <<(entry)
      downstream << entry.in_context(context_generator.call)
    end

    include SeverityThresholdSupport

  end

end
