# frozen_string_literal: true

require "green_log/entry"
require "green_log/severity"

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
        it "defaults to INFO" do
          expect(entry.severity).to eq(GreenLog::Severity::INFO)
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

      it "sets #message" do
        expect(entry.message).to eq("hello")
      end

    end

    context "with a :severity" do

      subject(:entry) do
        GreenLog::Entry.with(severity: "debug")
      end

      it "sets #severity" do
        expect(entry.severity).to eq(GreenLog::Severity::DEBUG)
      end

    end

    context "with a :context" do

      let(:test_context) do
        { colour: "red" }.freeze
      end

      subject(:entry) do
        GreenLog::Entry.with(context: test_context)
      end

      it "sets #context" do
        expect(entry.context).to eq(test_context)
      end

    end

    context "with :data" do

      let(:test_data) do
        { duration: 123 }.freeze
      end

      subject(:entry) do
        GreenLog::Entry.with(data: test_data)
      end

      it "sets #data" do
        expect(entry.data).to eq(test_data)
      end

    end

    context "with an exception" do

      let(:test_exception) do
        StandardError.new("argh")
      end

      subject(:entry) do
        GreenLog::Entry.with(exception: test_exception)
      end

      it "sets #exception" do
        expect(entry.exception).to be(test_exception)
      end

    end

  end

  describe ".build" do

    context "with a :severity" do

      subject(:entry) do
        GreenLog::Entry.build(GreenLog::Severity::WARN)
      end

      it "sets severity" do
        expect(entry.severity).to eq(GreenLog::Severity::WARN)
      end

    end

    let(:severity) { GreenLog::Severity::INFO }
    let(:message) { "Stuff happened" }

    context "with a String" do

      subject(:entry) do
        GreenLog::Entry.build(severity, message)
      end

      it "sets message" do
        expect(entry.message).to eq(message)
      end

    end

    context "with multiple Strings" do

      it "complains" do
        expect do
          GreenLog::Entry.build(severity, "Hello", "there")
        end.to raise_error(ArgumentError, "multiple message arguments specified")
      end

    end

    let(:data) { { x: 1, y: 2 } }

    context "with a Hash argument" do

      subject(:entry) do
        GreenLog::Entry.build(severity, data)
      end

      it "sets the data" do
        expect(entry.data).to eq(data)
      end

      it "does not set a message" do
        expect(entry.message).to be_nil
      end

    end

    context "with a Hash argument, unpacked" do

      subject(:entry) do
        GreenLog::Entry.build(severity, **data)
      end

      it "sets the data" do
        expect(entry.data).to eq(data)
      end

    end

    let(:exception) { StandardError.new("Ah, bugger!") }

    context "with an Exception argument" do

      subject(:entry) do
        GreenLog::Entry.build(severity, exception)
      end

      it "sets the exception" do
        expect(entry.exception).to eq(exception)
      end

      it "does not set a message" do
        expect(entry.message).to be_nil
      end

    end

    context "with String and Hash arguments" do

      subject(:entry) do
        GreenLog::Entry.build(severity, message, data)
      end

      it "sets the message" do
        expect(entry.message).to eq(message)
      end

      it "sets the data" do
        expect(entry.data).to eq(data)
      end

    end

    context "with String and Exception arguments" do

      subject(:entry) do
        GreenLog::Entry.build(severity, message, exception)
      end

      it "sets the message" do
        expect(entry.message).to eq(message)
      end

      it "sets the exception" do
        expect(entry.exception).to eq(exception)
      end

    end

    context "with a block that returns a String" do

      subject(:entry) do
        GreenLog::Entry.build(severity) do
          message
        end
      end

      it "sets the message" do
        expect(entry.message).to eq(message)
      end

    end

    context "with a block that returns an Array" do

      subject(:entry) do
        GreenLog::Entry.build(severity) do
          [message, data, exception]
        end
      end

      it "sets multiple components" do
        expect(entry.message).to eq(message)
        expect(entry.data).to eq(data)
        expect(entry.exception).to eq(exception)
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
