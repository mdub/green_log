# frozen_string_literal: true

require "green_log/logger"
require "green_log/severity"

RSpec.describe GreenLog::Logger do

  let(:entries) { [] }
  let(:log_sink) { entries.method(:<<) }
  let(:last_entry) { entries.last }

  subject(:logger) { described_class.new(log_sink) }

  describe "#info" do

    context "with a message" do

      before do
        logger.info("Hello")
      end

      it "logs the message" do
        expect(last_entry.message).to eq("Hello")
      end

      it "logs at severity INFO" do
        expect(last_entry.severity).to eq(GreenLog::Severity::INFO)
      end

    end

  end

  describe "#debug" do

    before do
      logger.debug("Watch out")
    end

    it "logs at severity DEBUG" do
      expect(last_entry.severity).to eq(GreenLog::Severity::DEBUG)
    end

  end

  describe "#warn" do

    before do
      logger.warn("Watch out")
    end

    it "logs at severity WARN" do
      expect(last_entry.severity).to eq(GreenLog::Severity::WARN)
    end

  end

  describe "#error" do

    before do
      logger.error("Watch out")
    end

    it "logs at severity ERROR" do
      expect(last_entry.severity).to eq(GreenLog::Severity::ERROR)
    end

  end

  describe "#fatal" do

    before do
      logger.fatal("Watch out")
    end

    it "logs at severity FATAL" do
      expect(last_entry.severity).to eq(GreenLog::Severity::FATAL)
    end

  end

end
