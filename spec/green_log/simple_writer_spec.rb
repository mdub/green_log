# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"
require "green_log/simple_writer"

RSpec.describe GreenLog::SimpleWriter do

  let(:buffer) { StringIO.new }
  let(:writer) { described_class.new(buffer) }

  def output
    buffer.string
  end

  def log(**args)
    writer << GreenLog::Entry.with(**args)
  end

  def self.log(**args)
    before do
      log(**args)
    end
  end

  def self.outputs(desc, expectation)
    it "outputs #{desc}" do
      expect(output).to match(expectation)
    end
  end

  describe "#<<" do

    context "a default entry" do
      log
      outputs "only severity", "I --\n"
    end

    context "with a :message" do
      log(message: "Hello")
      outputs "severity and message", "I -- Hello\n"
    end

    context "with a :severity" do
      log(severity: "WARN")
      outputs "first character of severity", /^W /
    end

    log_context = { colour: "yellow", flavour: "banana" }.freeze

    context "with a :context" do

      log(context: log_context)

      outputs "the context", <<~OUT
        I [colour="yellow" flavour="banana"] --
      OUT

    end

    log_data = { width: 3, height: 5 }.freeze

    context "with :data" do

      log(data: log_data)

      outputs "the data", <<~OUT
        I -- [width=3 height=5]
      OUT

    end

    context "with complex :data" do

      log(data: { user: { name: "Boris", id: 666 } })

      outputs "the data as properties", <<~OUT
        I -- [user.name="Boris" user.id=666]
      OUT

    end

    context "with all components" do

      log(message: "Hello", context: log_context, data: log_data)

      outputs "everything", <<~OUT
        I [colour="yellow" flavour="banana"] -- Hello [width=3 height=5]
      OUT

    end

    context "with an exception" do

      let(:exception) do

        raise ArgumentError, "wrong!"
      rescue StandardError => e
        e

      end

      before do
        log(exception: exception)
      end

      it "outputs exception class and message" do
        expect(output).to match <<~OUT
          I --
            ! ArgumentError: wrong!
        OUT
      end

      it "outputs exception backtrace" do
        expect(output).to match(/(^    \S+:\d+:in .+$)+/)
      end

    end

  end

end
