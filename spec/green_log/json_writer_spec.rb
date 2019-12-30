# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"
require "green_log/json_writer"
require "json"

RSpec.describe GreenLog::JsonWriter do

  let(:buffer) { StringIO.new }
  let(:writer) { described_class.new(buffer) }

  def output
    buffer.string
  end

  def output_data
    JSON.parse(buffer.string.each_line.first)
  end

  def log(**args)
    writer << GreenLog::Entry.with(**args)
  end

  describe "#<<" do

    context "with a simple message" do

      let(:message) { "You've been warned" }

      before do
        log(severity: "WARN", message: message)
      end

      it "includes the message" do
        expect(output_data).to include("message" => message)
      end

      it "includes severity" do
        expect(output_data).to include("severity" => "WARN")
      end

    end

  end

  context "with context" do

    before do
      log(context: { thread: "main" })
    end

    it "includes the message" do
      expect(output_data).to include(
        "context" => {
          "thread" => "main",
        },
      )
    end

  end

  context "with data" do

    before do
      log(data: { duration: 42 })
    end

    it "includes the data" do
      expect(output_data).to include(
        "data" => {
          "duration" => 42,
        },
      )
    end

  end

end
