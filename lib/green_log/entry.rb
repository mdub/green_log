# frozen_string_literal: true

require "green_log/severity"
require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:severity, :message, :context, :data, :exception)

    def self.with(
      severity: nil, message: nil,
      context: nil, data: nil, exception: nil
    )
      super(
        severity: Severity.resolve(severity || Severity::INFO),
        message: message,
        context: (context || {}),
        data: (data || {}),
        exception: exception,
      )
    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
