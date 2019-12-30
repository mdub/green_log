# frozen_string_literal: true

require "green_log/severity"

module GreenLog

  # Log middleware that filters by severity.
  class SeverityFilter

    def initialize(downstream, threshold:)
      @downstream = downstream
      @severity_threshold = GreenLog::Severity.resolve(threshold)
    end

    attr_reader :downstream
    attr_reader :severity_threshold

    def <<(entry)
      return if entry.severity < severity_threshold

      downstream << entry
    end

  end

end
