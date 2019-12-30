# frozen_string_literal: true

require "green_log/severity"
require "green_log/severity_threshold_support"

RSpec.describe GreenLog::SeverityThresholdSupport do

  include GreenLog::SeverityThresholdSupport

  let(:downstream) { [] }

  describe "#severity_threshold" do

    context "when downstream doesn't implement #severity_threshold" do

      it "returns DEBUG" do
        expect(severity_threshold).to eq(GreenLog::Severity::DEBUG)
      end

    end

    context "when downstream implements #severity_threshold" do

      before do
        allow(downstream).to receive(:severity_threshold).and_return(GreenLog::Severity::FATAL)
      end

      it "returns the downstream threshold" do
        expect(severity_threshold).to eq(GreenLog::Severity::FATAL)
      end

    end

  end

end
