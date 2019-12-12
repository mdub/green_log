# frozen_string_literal: true

module GreenLog

  # Represents a structured log entry.
  class Entry

    def initialize(message: nil, severity: :info)
      @message = message
      @severity = severity
    end

    attr_reader :message
    attr_reader :severity

  end

end
