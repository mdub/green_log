# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"

module GreenLog

  # A JSON-formated log.
  class JsonWriter

    def initialize(dest)
      @dest = dest
    end

    attr_reader :dest

    def <<(entry)
      raise ArgumentError, "GreenLog::Entry expected" unless entry.is_a?(GreenLog::Entry)

      dest << JSON.dump(entry_details(entry)) + "\n"
    end

    protected

    def entry_details(entry)
      {
        "severity" => Severity.name(entry.severity).upcase,
        "message" => entry.message,
        "data" => entry.data,
        "context" => entry.context,
        "exception" => exception_details(entry.exception),
      }.compact
    end

    def exception_details(exception)
      return nil if exception.nil?

      {
        "class" => exception.class.name,
        "message" => exception.message,
        "backtrace" => exception.backtrace,
      }
    end

  end

end
