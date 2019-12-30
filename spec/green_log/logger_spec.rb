# frozen_string_literal: true

require "green_log/logger"
require "green_log/severity"

RSpec.describe GreenLog::Logger do

  let(:log) { [] }

  subject(:logger) { described_class.new(log) }

  describe "#severity_threshold" do

    it "defaults to DEBUG" do
      expect(logger.severity_threshold).to eq(GreenLog::Severity::DEBUG)
    end

  end

  describe "#log" do

    let(:severity) { GreenLog::Severity::INFO }
    let(:message) { "Stuff happened" }
    let(:data) { { x: 1, y: 2 } }
    let(:exception) { StandardError.new("Ah, bugger!") }

    context "with a String argument" do

      before do
        logger.log(severity, message)
      end

      it "sets the message" do
        expect(log.last.message).to eq(message)
      end

    end

    context "with a Hash argument" do

      before do
        logger.log(severity, data)
      end

      it "sets the data" do
        expect(log.last.data).to eq(data)
      end

    end

    context "with an Exception argument" do

      before do
        logger.log(severity, exception)
      end

      it "sets the exception" do
        expect(log.last.exception).to eq(exception)
      end

    end

    context "with a block" do

      before do
        logger.log(severity) do |e|
          e.message = message
          e.data = data
        end
      end

      it "allows properties to be set" do
        expect(log.last.message).to eq(message)
        expect(log.last.data).to eq(data)
      end

    end

  end

  describe "#debug" do

    before do
      logger.debug("Watch out")
    end

    it "logs at severity DEBUG" do
      expect(log.last.severity).to eq(GreenLog::Severity::DEBUG)
    end

  end

  describe "#info" do

    before do
      logger.info("Watch out")
    end

    it "logs at severity INFO" do
      expect(log.last.severity).to eq(GreenLog::Severity::INFO)
    end

  end

  describe "#warn" do

    before do
      logger.warn("Watch out")
    end

    it "logs at severity WARN" do
      expect(log.last.severity).to eq(GreenLog::Severity::WARN)
    end

  end

  describe "#error" do

    before do
      logger.error("Watch out")
    end

    it "logs at severity ERROR" do
      expect(log.last.severity).to eq(GreenLog::Severity::ERROR)
    end

  end

  describe "#fatal" do

    before do
      logger.fatal("Watch out")
    end

    it "logs at severity FATAL" do
      expect(log.last.severity).to eq(GreenLog::Severity::FATAL)
    end

  end

  describe "#with_context" do

    let(:message) { "Stuff happened" }
    let(:context) { { thread: "main" } }

    let!(:logger_with_context) do
      logger.with_context(context)
    end

    it "adds context to log entries" do
      logger_with_context.info(message)
      expect(log.last.context).to eq(context)
      expect(log.last.message).to eq(message)
    end

  end

  context "#with_severity_threshold" do

    let(:severity_threshold) { GreenLog::Severity::ERROR }

    subject(:logger) do
      described_class.new(log).with_severity_threshold(severity_threshold)
    end

    describe "#severity_threshold" do

      it "returns the downstream threshold" do
        expect(logger.severity_threshold).to eq(severity_threshold)
      end

    end

    describe "#log" do

      context "with severity at or above the threshold" do

        it "logs events" do
          logger.log(severity_threshold, "Stuff happened")
          logger.log(severity_threshold + 1, "More stuff happened")
          expect(log.size).to eq(2)
        end

        it "returns true" do
          return_value = logger.log(severity_threshold, "Blah")
          expect(return_value).to be(true)
        end

      end

      context "with severity below the threshold" do

        it "logs nothing" do
          logger.log(severity_threshold - 1, "More stuff happened")
          expect(log).to be_empty
        end

        it "does not evaluate blocks" do
          block_evaluated = false
          logger.log(severity_threshold - 1) do
            block_evaluated = true
            "Unused message"
          end
          expect(block_evaluated).to be(false)
        end

        it "returns false" do
          return_value = logger.log(severity_threshold - 1, "Blah")
          expect(return_value).to be(false)
        end

      end

    end

  end

end
