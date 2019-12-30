# frozen_string_literal: true

module GreenLog

  # Log middleware that filters by severity.
  class SeverityFilter

    def initialize(downstream, threshold:)
      @downstream = downstream
      @threshold = threshold
    end

    attr_reader :downstream
    attr_reader :threshold

    def <<(entry)
      return if entry.severity < threshold

      downstream << entry
    end

  end

end
