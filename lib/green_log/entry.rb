# frozen_string_literal: true

require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:message, :severity, :context)

    def initialize(message: nil, severity: :info, context: {})
      super(message, severity, context)
    end

  end

end
