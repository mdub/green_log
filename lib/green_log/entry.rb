# frozen_string_literal: true

require "green_log/severity"
require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:message, :severity, :context)

    def self.with(message: nil, severity: nil, context: nil)
      super(
        message: message,
        severity: Severity.resolve(severity || Severity::INFO),
        context: (context || {})
      )
    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
