# frozen_string_literal: true

require "green_log/loggable/hash"

RSpec.describe GreenLog::Loggable::Hash do

  context "constructed with no args" do

    subject(:loggable_hash) do
      described_class.new
    end

    it "is empty" do
      expect(subject).to be_empty
    end

    describe "#to_h" do
      it "returns an empty Hash" do
        expect(subject.to_h).to eq({})
      end
    end

  end

  subject(:loggable_hash) do
    described_class.new(input_hash)
  end

  context "constructed with a simple Hash of values" do

    let(:input_hash) { { x: "juan", y: 2 } }

    it "is not empty" do
      expect(subject).to_not be_empty
    end

    describe "#to_h" do
      it "returns the input Hash" do
        expect(subject.to_h).to eq(input_hash)
      end
    end

    it "is not coupled to the input Hash" do
      original_input = input_hash.dup
      expect(subject.to_h).to eq(original_input)
      input_hash[:x] = "fnord"
      expect(subject.to_h).to eq(original_input)
    end

    describe "#merge" do

      subject(:result) do
        loggable_hash.merge(new_data)
      end

      context "with a ::Hash" do

        let(:new_data) do
          { x: 11, flavour: "mud" }
        end

        it "returns a new Loggable::Hash" do
          expect(result).to be_kind_of(described_class)
        end

        it "works like Hash#merge" do
          expect(result.to_h).to eq(loggable_hash.to_h.merge(new_data))
        end

      end

    end

  end

  context "with String keys" do

    let(:input_hash) do
      {
        "host" => "foo.example.com",
        "thread" => {
          "name" => "main"
        }
      }
    end

    it "symbolises the keys" do
      expect(subject.to_h).to include(
        host: "foo.example.com"
      )
    end

    it "symbolises deeply" do
      expect(subject.to_h).to include(
        thread: {
          name: "main"
        }
      )
    end

  end

  context "with an Array value" do

    let(:input_hash) do
      {
        "stuff" => [1, 2, 3]
      }
    end

    it "whines" do
      expect { subject }.to raise_error(ArgumentError, "arrays not supported here")
    end

  end

end
