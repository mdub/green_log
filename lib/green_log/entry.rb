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
          options[arg_type(arg)] = arg
        end
        with(options)
      end

      private

      def arg_type(arg)
        case arg
        when String
          :message
        when Hash
          :data
        when Exception
          :exception
        else
          raise ArgumentError, "un-loggable argument: #{arg.inspect}"
        end
      end

    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

  end

end
