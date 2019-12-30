# frozen_string_literal: true

require "green_log/severity"

module GreenLog

  # Common logic for deriving a #severity_threshold.
  module SeverityThresholdSupport

    def severity_threshold
      return downstream.severity_threshold if downstream.respond_to?(:severity_threshold)

      GreenLog::Severity::DEBUG
    end

  end

end
