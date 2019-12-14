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

  def self.log(**args)
    before do
      log(**args)
    end
  end

  def self.logging(desc, **args, &block)
    context(desc) do
      log(**args)
      class_eval(&block)
    end
  end

  def self.outputs(desc, expectation)
    it "outputs #{desc}" do
      expect(output).to match(expectation)
    end
  end

  describe "#call" do

    context "a default entry" do
      log
      outputs "only severity", "I --\n"
    end

    context "with a :message" do
      log(message: "Hello")
      outputs "severity and message", "I -- Hello\n"
    end

    context "with a :severity" do
      log(severity: :warn)
      outputs "first character of severity", /^W /
    end

    context "with a :context" do

      log(context: { colour: "yellow", flavour: "banana" })

      outputs "the context", <<~OUT
        I [colour="yellow" flavour="banana"] --
      OUT

    end

    context "with all components" do

      log(message: "Hello", context: { colour: "yellow", flavour: "banana" })

      outputs "everything", <<~OUT
        I [colour="yellow" flavour="banana"] -- Hello
      OUT

    end

  end

end
