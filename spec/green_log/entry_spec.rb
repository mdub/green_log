# frozen_string_literal: true

require "green_log/entry"

RSpec.describe GreenLog::Entry do

  def new_entry(**args)
    described_class.new(**args)
  end

  describe "#message" do

    it "defaults to nil" do
      expect(new_entry.message).to be_nil
    end

    it "can be specified" do
      e = new_entry(message: "foo")
      expect(e.message).to eq("foo")
    end

    it "is immutable" do
      expect(new_entry).not_to respond_to(:message=)
    end

  end

  describe "#severity" do

    it "defaults to :info" do
      expect(new_entry.severity).to eq(:info)
    end

    it "can be overridden" do
      e = new_entry(severity: :debug)
      expect(e.severity).to eq(:debug)
    end

    it "is immutable" do
      expect(new_entry).not_to respond_to(:severity=)
    end

  end

  describe "#context" do

    it "defaults to empty" do
      expect(new_entry.context).to eq({})
    end

    it "can be overridden" do
      test_context = { colour: "red" }.freeze
      e = new_entry(context: test_context)
      expect(e.context).to eq(test_context)
    end

    it "is immutable" do
      expect(new_entry).not_to respond_to(:context=)
    end

  end

end
