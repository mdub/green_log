# frozen_string_literal: true

require "green_log/severity"
require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:severity, :message, :context, :data, :exception)

    class << self

      def with(**args)
        args[:severity] = Severity.resolve(
          args.fetch(:severity, Severity::INFO)
        )
        args[:message] ||= nil
        args[:context] ||= {}
        args[:data] ||= {}
        args[:exception] ||= nil
        super(**args)
      end

      def build(*args, severity: Severity::INFO)
        options = { severity: severity }
        args.each do |arg|
          case arg
          when String
            options[:message] = arg
          when Hash
            options[:data] = arg
          end
        end
        with(options)
      end

    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
