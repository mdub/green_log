# frozen_string_literal: true

require "green_log/severity"
require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:severity, :message, :context, :data, :exception)

    def self.with(**args)
      args[:severity] = Severity.resolve(args.fetch(:severity, Severity::INFO))
      args[:message] ||= nil
      args[:context] ||= {}
      args[:data] ||= {}
      args[:exception] ||= nil
      super(**args)
    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
