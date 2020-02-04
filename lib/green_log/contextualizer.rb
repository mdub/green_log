# frozen_string_literal: true

require "green_log/severity_threshold_support"

module GreenLog

  # Log middleware that adds context.
  class Contextualizer

    def initialize(downstream, &context_generator)
      @downstream = downstream
      @context_generator = context_generator
    end

    attr_reader :downstream
    attr_reader :context_generator

    def <<(entry)
      downstream << entry.in_context(context_generator.call)
    end

    include SeverityThresholdSupport

  end

end
