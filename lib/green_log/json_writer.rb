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

      record = {
        "severity" => Severity.name(entry.severity).upcase,
        "message" => entry.message,
        "data" => entry.data,
        "context" => entry.context,
      }
      dest << JSON.dump(record) + "\n"
    end

  end

end
