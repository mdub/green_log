# frozen_string_literal: true

require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:message, :severity, :context)

    def self.with(message: nil, severity: nil, context: nil)
      super(
        message: message,
        severity: (severity || :info),
        context: (context || {})
      )
    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
