# frozen_string_literal: true

require "green_log/severity_threshold_support"

module GreenLog

  # Log middleware that adds context.
  class Contextualizer

    def initialize(downstream, context)
      @downstream = downstream
      @context = context
    end

    attr_reader :downstream
    attr_reader :context

    def <<(entry)
      downstream << entry.in_context(context)
    end

    include SeverityThresholdSupport

  end

end
