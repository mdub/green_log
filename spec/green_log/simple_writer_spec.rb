
require "green_log/entry"
require "green_log/simple_writer"

RSpec.describe GreenLog::SimpleWriter do

  let(:buffer) { StringIO.new }
  let(:writer) { described_class.new(buffer) }

  def output
    buffer.string
  end

  def log(**args)
    entry = GreenLog::Entry.new(**args)
    writer.call(entry)
  end

  describe "#call" do

    context "with a :message" do

      before do
        log(message: "Hello there")
      end

      it "outputs the message" do
        expect(output).to eq(<<~EOT)
          "Hello there"
        EOT
      end

    end

  end

end
