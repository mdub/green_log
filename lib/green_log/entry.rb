# frozen_string_literal: true

require "green_log/core_refinements"
require "green_log/severity"

module GreenLog

  # Represents a structured log entry.
  class Entry

    using CoreRefinements

    def initialize(severity:, message:, context:, data:, exception:)
      @severity = severity
      @message = message
      @context = context
      @data = data
      @exception = exception
    end

    attr_reader :severity
    attr_reader :message
    attr_reader :context
    attr_reader :data
    attr_reader :exception

    class << self

      def with(**args)
        args[:severity] = Severity.resolve(
          args.fetch(:severity, Severity::INFO),
        )
        args[:message] ||= nil
        args[:context] = args.fetch(:context, {}).to_loggable_value
        args[:data] = args.fetch(:data, {}).to_loggable_value
        args[:exception] ||= nil
        new(**args)
      end

      def build(severity, *args, &block)
        Builder.new(severity).build(*args, &block)
      end

    end

    def in_context(extra_context)
      Entry.new(
        severity: severity,
        message: message,
        context: extra_context.integrate(context).to_loggable_value,
        data: data,
        exception: exception,
      )
    end

    # A builder for entries.
    class Builder

      def initialize(severity)
        @severity = severity
      end

      attr_reader :severity
      attr_reader :message
      attr_reader :data
      attr_reader :exception

      def message=(arg)
        raise ArgumentError, ":message already specified" if defined?(@message)

        @message = arg
      end

      def data=(arg)
        raise ArgumentError, ":data already specified" if defined?(@data)

        @data = arg
      end

      def exception=(arg)
        raise ArgumentError, ":exception already specified" if defined?(@exception)

        @exception = arg
      end

      def build(*args, &block)
        args.each(&method(:handle_arg))
        if block
          if block.arity.zero?
            Array(block.call).each(&method(:handle_arg))
          else
            block.call(self)
          end
        end
        Entry.with(severity: severity, message: message, data: data, exception: exception)
      end

      private

      def handle_arg(arg)
        public_send("#{arg_type(arg)}=", arg)
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
