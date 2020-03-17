# frozen_string_literal: true

require "green_log/entry"
require "green_log/null_writer"
require "green_log/severity"

RSpec.describe GreenLog::NullWriter do

  let(:buffer) { StringIO.new }
  let(:writer) { described_class.new }

  def log(**args)
    writer << GreenLog::Entry.with(**args)
  end

  describe "#<<" do

    context "with a simple message" do

      it "does nothing" do
        log(message: "This message will be totally ignored")
      end

    end

  end

  describe "#severity_threshold" do

    it "returns FATAL" do
      expect(writer.severity_threshold).to eq(GreenLog::Severity::FATAL)
    end

  end

end
