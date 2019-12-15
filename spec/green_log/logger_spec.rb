# frozen_string_literal: true

require "green_log/logger"
require "green_log/severity"

RSpec.describe GreenLog::Logger do

  let(:log) { [] }
  let(:last_entry) { log.last }

  subject(:logger) { described_class.new(log) }

  describe "#level" do

    it "defaults to DEBUG" do
      expect(logger.level).to eq(GreenLog::Severity::DEBUG)
    end

    it "can be set as a numeric value" do
      logger.level = GreenLog::Severity::WARN
      expect(logger.level).to eq(GreenLog::Severity::WARN)
    end

    it "can be set as a string" do
      logger.level = "WARN"
      expect(logger.level).to eq(GreenLog::Severity::WARN)
    end

  end

  describe "#log" do

    before do
      logger.level = "WARN"
    end

    context "with severity at or above the specified threshold" do

      before do
        logger.log(logger.level, "Stuff happened")
        logger.log(logger.level + 1, "More stuff happened")
      end

      it "logs events" do
        expect(log.size).to eq(2)
      end

    end

    context "with severity below the specified threshold" do

      before do
        logger.log(logger.level - 1, "Boring stuff")
      end

      it "logs nothing" do
        expect(log).to be_empty
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

  describe "#info" do

    before do
      logger.info("Watch out")
    end

    it "logs at severity INFO" do
      expect(last_entry.severity).to eq(GreenLog::Severity::INFO)
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
