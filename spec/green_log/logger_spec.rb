# frozen_string_literal: true

require "green_log/logger"
require "green_log/severity"

RSpec.describe GreenLog::Logger do

  let(:log) { [] }
  let(:log_sink) { log.method(:<<) }
  let(:last_entry) { log.last }

  subject(:logger) { described_class.new(log_sink) }

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

  context "with a specified level" do

    before do
      logger.level = "WARN"
    end

    it "logs events at the specific level" do
      logger.warn("Warning")
      expect(last_entry.message).to eq("Warning")
    end

    it "logs events above the specific level" do
      logger.error("Oh sh!t")
      expect(last_entry.message).to eq("Oh sh!t")
    end

    it "ignores events below that level" do
      logger.info("Stuff happened")
      expect(log).to be_empty
    end

  end

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

    context "with logger level WARN" do

      before do
        logger.level = "WARN"
        logger.info("Stuff happened")
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
