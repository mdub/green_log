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

  end

  describe "#severity" do

    it "defaults to :info" do
      expect(new_entry.severity).to eq(:info)
    end

    it "can be overridden" do
      e = new_entry(severity: :debug)
      expect(e.severity).to eq(:debug)
    end

  end

end
