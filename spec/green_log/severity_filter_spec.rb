# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity_filter"

RSpec.describe GreenLog::SeverityFilter do

  let(:log) { [] }

  let(:severity_threshold) { GreenLog::Severity::WARN }

  subject(:severity_filter) do
    described_class.new(log, threshold: severity_threshold)
  end

  def entry_with_severity(severity)
    GreenLog::Entry.with(severity: severity)
  end

  describe "#<<" do

    it "passes entries at the severity threshold" do
      entry = entry_with_severity(severity_threshold)
      subject << entry
      expect(log).to eq([entry])
    end

    it "passes entries above the severity threshold" do
      entry = entry_with_severity(severity_threshold + 1)
      subject << entry
      expect(log).to eq([entry])
    end

    it "swallows entries below the severity threshold" do
      entry = entry_with_severity(severity_threshold - 1)
      subject << entry
      expect(log).to be_empty
    end

  end

end
