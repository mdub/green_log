# frozen_string_literal: true

require "green_log/entry"

RSpec.describe GreenLog::Entry do

  describe ".with" do

    context "by default" do

      subject(:entry) do
        GreenLog::Entry.with({})
      end

      describe "#message" do
        it "defaults nil" do
          expect(entry.message).to be_nil
        end
      end

      describe "#severity" do
        it "defaults to :info" do
          expect(entry.severity.to_sym).to eq(:info)
        end
      end

      describe "#context" do
        it "defaults to empty" do
          expect(entry.context.to_h).to eq({})
        end
      end

    end

    context "with a :message" do

      subject(:entry) do
        GreenLog::Entry.with(message: "hello")
      end

      describe "#message" do
        it "is set" do
          expect(entry.message).to eq("hello")
        end
      end

    end

    context "with a :severity" do

      subject(:entry) do
        GreenLog::Entry.with(severity: :debug)
      end

      describe "#severity" do
        it "is set" do
          expect(entry.severity).to eq(:debug)
        end
      end

    end

    context "with a :context" do

      let(:test_context) do
        { colour: "red" }.freeze
      end

      subject(:entry) do
        GreenLog::Entry.with(context: :debug)
      end

      describe "#context" do
        it "is set" do
          expect(entry.context).to eq(:debug)
        end
      end

    end

  end

  describe "#with_context" do

    let(:original_context) do
      {
        colour: "red",
        flavour: "strawberry"
      }
    end

    subject(:original_entry) do
      GreenLog::Entry.with(context: original_context)
    end

    let(:extra_context) do
      {
        flavour: "watermelon",
        direction: "north"
      }
    end

    let!(:result) do
      original_entry.with_context(extra_context)
    end

    it "adds the new context" do
      expect(result.context).to include(direction: "north")
    end

    it "overrides values as required" do
      expect(result.context).to include(colour: "red")
    end

    it "retains other context" do
      expect(result.context).to include(colour: "red")
    end

  end

end
