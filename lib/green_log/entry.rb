# frozen_string_literal: true

require "green_log/core_refinements"
require "green_log/severity"
require "values"

module GreenLog

  # Represents a structured log entry.
  class Entry < Value.new(:severity, :message, :context, :data, :exception)

    using CoreRefinements

    class << self

      def with(**args)
        args[:severity] = Severity.resolve(
          args.fetch(:severity, Severity::INFO)
        )
        args[:message] ||= nil
        args[:context] = args.fetch(:context, {}).to_loggable
        args[:data] = args.fetch(:data, {}).to_loggable
        args[:exception] ||= nil
        super(**args)
      end

      def build(severity, *args, &block)
        Builder.new(severity).build(*args, &block)
      end

    end

    def in_context(extra_context)
      with(context: extra_context.integrate(context).to_loggable)
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
