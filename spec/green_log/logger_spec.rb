# frozen_string_literal: true

require "green_log/logger"

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

      it "logs at severity :info" do
        expect(last_entry.severity).to eq(:info)
      end

    end

  end

end
