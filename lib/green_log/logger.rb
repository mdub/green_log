# frozen_string_literal: true

require "green_log/entry"

module GreenLog

  # Represents a structured log entry.
  class Logger

    def initialize(downstream)
      @downstream = downstream
    end

    attr_reader :downstream

    def info(message)
      downstream.call(Entry.with(message: message))
    end

  end

end
