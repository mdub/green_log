# frozen_string_literal: true

require "green_log/classic_logger"
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

    context "with nil message" do

      it "raises an error" do
        expect do
          logger.add(Logger::WARN, nil)
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

end
