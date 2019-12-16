# frozen_string_literal: true

module GreenLog

  # Represents a structured log entry.
  class Contextualizer

    def initialize(downstream, context)
      @downstream = downstream
      @context = context
    end

    attr_reader :downstream
    attr_reader :context

    def <<(entry)
      downstream << entry.with_context(context)
    end

  end

end
