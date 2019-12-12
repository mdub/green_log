# frozen_string_literal: true

module GreenLog

  # Represents a structured log entry.
  class Entry

    def initialize(message: nil, severity: :info, context: {})
      @message = message
      @severity = severity
      @context = context
    end

    attr_reader :message
    attr_reader :severity
    attr_reader :context

  end

end
