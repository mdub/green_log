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

      def build(severity, *args, &block)
        Builder.new(severity).build(*args, &block)
      end

    end

    def with_context(extra_context)
      with(context: context.merge(extra_context))
    end

    # A builder for entries.
    class Builder

      def initialize(severity)
        @options = { severity: severity }
      end

      attr_reader :options

      def build(*args, &block)
        args.each(&method(:handle_arg))
        if block
          values_from_block = Array(block.call)
          values_from_block.each(&method(:handle_arg))
        end
        Entry.with(options)
      end

      private

      def handle_arg(arg)
        type = arg_type(arg)
        raise ArgumentError, "multiple #{type} arguments specified" if options.key?(type)

        options[type] = arg
      end

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

  end

end
