# frozen_string_literal: true

require "green_log/severity"

RSpec.describe GreenLog::Severity do

  describe ".resolve" do

    def resolve(arg)
      GreenLog::Severity.resolve(arg)
    end

    context "with a severity value" do
      it "returns the value" do
        input = GreenLog::Severity::WARN
        expect(resolve(input)).to eq(input)
      end
    end

    context "with an uppercase severity value" do
      it "returns the corresponding value" do
        expect(resolve("WARN")).to eq(GreenLog::Severity::WARN)
      end
    end

    context "with a lowercase severity value" do
      it "returns the corresponding value" do
        expect(resolve("fatal")).to eq(GreenLog::Severity::FATAL)
      end
    end

    context "with a symbolic severity value" do
      it "returns the corresponding value" do
        expect(resolve(:debug)).to eq(GreenLog::Severity::DEBUG)
      end
    end

    context "with an out-of-range integer value" do
      it "raises an ArgumentError" do
        expect { resolve(7) }.to raise_error(ArgumentError)
        expect { resolve(-1) }.to raise_error(ArgumentError)
      end
    end

    context "with an unrecognised severity name" do
      it "raises an ArgumentError" do
        expect { resolve("hint") }.to raise_error(ArgumentError)
      end
    end

  end

end
