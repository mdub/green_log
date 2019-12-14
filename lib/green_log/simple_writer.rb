# frozen_string_literal: true

require "green_log/severity"

module GreenLog

  # A simple log formatter, aimed at humans.
  class SimpleWriter

    def initialize(io)
      @io = io
    end

    def call(entry)
      @io << [
        format_part(entry, :severity),
        format_part(entry, :context),
        "--",
        format_part(entry, :message)
      ].compact.join(" ") + "\n"
    end

    protected

    def format_part(entry, part)
      value = entry.public_send(part)
      return nil if value.nil?

      send("format_#{part}", value)
    end

    def format_severity(severity)
      Severity.name(severity)[0].upcase
    end

    def format_context(context)
      return nil if context.empty?

      parts = context.map { |k, v| "#{k}=#{v.inspect}" }
      "[" + parts.join(" ") + "]"
    end

    def format_message(message)
      message
    end

  end

end
