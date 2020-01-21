# frozen_string_literal: true

require "green_log/classic_logger"
require "green_log/severity_filter"
require "logger"

RSpec.describe GreenLog::ClassicLogger do

  let(:log) { [] }

  subject(:logger) { described_class.new(log) }

  let(:message) { "Take note!" }

  describe "#add" do

    context "with severity and message" do

      before do
        @return_value = logger.add(Logger::WARN, message)
      end

      it "logs the message" do
        expect(log.last.message).to eq(message)
      end

      it "logs at the specified severity" do
        expect(log.last.severity).to eq(GreenLog::Severity::WARN)
      end

      it "returns true" do
        expect(@return_value).to be(true)
      end

    end

    context "with a block" do

      before do
        logger.add(Logger::WARN) { message }
      end

      it "logs the yielded message" do
        expect(log.last.message).to eq(message)
      end

    end

    context "with neither message or block" do

      it "raises an error" do
        expect do
          logger.add(Logger::WARN)
        end.to raise_error(ArgumentError, "no message provided")
      end

    end

    context "with message AND block" do

      it "raises an error" do
        expect do
          logger.add(Logger::WARN, "foo") { "bar" }
        end.to raise_error(ArgumentError, "both message and block provided")
      end

    end

    context "with nil message" do

      before do
        logger.add(Logger::WARN, nil)
      end

      it "logs 'nil'" do
        expect(log.last.message).to eq(nil.inspect)
      end

    end

    context "with an exception" do

      let(:exception) { StandardError.new("Oh god") }

      before do
        logger.add(Logger::WARN, exception)
      end

      it "logs the exception" do
        expect(log.last.exception).to eq(exception)
      end

      it "leave the message blank" do
        expect(log.last.message).to be(nil)
      end

    end

    context "with complex data" do

      let(:data) { [1, 2, 3] }

      before do
        logger.add(Logger::WARN, data)
      end

      it "calls inspect to create a message" do
        expect(log.last.message).to eq(data.inspect)
      end

    end

  end

  describe "#debug" do

    context "with a message" do

      before do
        @return_value = logger.debug(message)
      end

      it "logs the message" do
        expect(log.last.message).to eq(message)
      end

      it "logs at DEBUG severity" do
        expect(log.last.severity).to eq(GreenLog::Severity::DEBUG)
      end

      it "returns true" do
        expect(@return_value).to be(true)
      end

    end

    context "with a block" do

      before do
        @return_value = logger.debug { message }
      end

      it "logs the yielded message" do
        expect(log.last.message).to eq(message)
      end

      it "returns true" do
        expect(@return_value).to be(true)
      end

    end

  end

  describe "#info" do

    before do
      logger.info(message)
    end

    it "logs at INFO severity" do
      expect(log.last.severity).to eq(GreenLog::Severity::INFO)
    end

  end

  describe "#warn" do

    before do
      logger.warn(message)
    end

    it "logs at WARN severity" do
      expect(log.last.severity).to eq(GreenLog::Severity::WARN)
    end

  end

  describe "#error" do

    before do
      logger.error(message)
    end

    it "logs at ERROR severity" do
      expect(log.last.severity).to eq(GreenLog::Severity::ERROR)
    end

  end

  describe "#fatal" do

    before do
      logger.fatal(message)
    end

    it "logs at FATAL severity" do
      expect(log.last.severity).to eq(GreenLog::Severity::FATAL)
    end

  end

  context "with a SeverityFilter" do

    let(:severity_threshold) { GreenLog::Severity::WARN }

    subject(:logger) do
      described_class.new(
        GreenLog::SeverityFilter.new(log, threshold: severity_threshold),
      )
    end

    describe "#add" do

      context "with severity at or above the threshold" do

        before do
          logger.add(severity_threshold, "Stuff happened")
          logger.add(severity_threshold + 1, "Bad stuff happened")
        end

        it "logs events" do
          expect(log.size).to eq(2)
        end

      end

      context "with severity below the threshold" do

        it "logs nothing" do
          logger.add(severity_threshold - 1, "Detailed stuff happened")
          expect(log).to be_empty
        end

        it "does not evaluate blocks" do
          block_evaluated = false
          logger.add(severity_threshold - 1) do
            block_evaluated = true
            "Unused message"
          end
          expect(block_evaluated).to be(false)
        end

      end

    end

    describe "each predicate method" do

      context "at or above the threshold" do

        it "returns true" do
          expect(logger.warn?).to be(true)
          expect(logger.error?).to be(true)
          expect(logger.fatal?).to be(true)
        end

      end

      context "below the threshold" do

        it "returns false" do
          expect(logger.debug?).to be(false)
          expect(logger.info?).to be(false)
        end

      end

    end

  end

end

RSpec.describe GreenLog::Logger do

  let(:log) { [] }

  subject(:logger) { described_class.new(log) }

  describe "#to_classic_logger" do

    let(:result) { logger.to_classic_logger }

    it "returns a ClassicLogger" do
      expect(result).to be_a(GreenLog::ClassicLogger)
    end

    it "uses the same downstream" do
      expect(result.downstream).to be(logger.downstream)
    end

  end

end
