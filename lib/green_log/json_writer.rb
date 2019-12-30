# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"

module GreenLog

  # A JSON-formated log.
  class JsonWriter

    def initialize(io)
      @io = io
    end

    attr_reader :io

    def <<(entry)
      raise ArgumentError, "GreenLog::Entry expected" unless entry.is_a?(GreenLog::Entry)

      record = {
        "severity" => Severity.name(entry.severity).upcase,
        "message" => entry.message,
        "data" => entry.data,
        "context" => entry.context,
      }
      io << JSON.dump(record) + "\n"
    end

  end

end
