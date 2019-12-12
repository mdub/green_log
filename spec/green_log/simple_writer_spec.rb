# frozen_string_literal: true

require "green_log/entry"
require "green_log/simple_writer"

RSpec.describe GreenLog::SimpleWriter do

  let(:buffer) { StringIO.new }
  let(:writer) { described_class.new(buffer) }

  def output
    buffer.string
  end

  def log(**args)
    entry = GreenLog::Entry.with(**args)
    writer.call(entry)
  end

  describe "#call" do

    context "with a default entry" do

      before do
        log
      end

      it "outputs only severity" do
        expect(output).to eq(<<~OUT)
          I --
        OUT
      end

    end

    context "with a :message" do

      before do
        log(severity: :info, message: "Hello there")
      end

      it "outputs severity and message" do
        expect(output).to eq(<<~OUT)
          I -- Hello there
        OUT
      end

    end

    context "with a :severity" do

      before do
        log(severity: :warn)
      end

      it "outputs first character of severity" do
        expect(output).to start_with("W ")
      end

    end

    context "with a :context" do

      let(:context) do
        {
          colour: "yellow",
          flavour: "banana"
        }
      end

      before do
        log(message: "Hello", context: context)
      end

      it "outputs severity and message" do
        expect(output).to eq(<<~OUT)
          I [colour="yellow" flavour="banana"] -- Hello
        OUT
      end

    end

  end

end
