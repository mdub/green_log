# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"
require "json"

module GreenLog

  # A road to nowhere.
  class NullWriter

    def initialize
    end

    def <<(_entry)
    end

    def severity_threshold
      Severity::FATAL
    end

  end

end
