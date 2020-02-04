# frozen_string_literal: true

require "green_log/contextualizer"
require "green_log/entry"

RSpec.describe GreenLog::Contextualizer do

  let(:log) { [] }

  let(:input_context) { {}.freeze }

  let(:input_entry) do
    GreenLog::Entry.with(message: "Hello", context: input_context)
  end

  let(:extra_context) { { pid: 123, thread: "main" } }

  subject(:contextualizer) do
    described_class.new(log) { extra_context }
  end

  before do
    contextualizer << input_entry
  end

  it "passes entries downstream" do
    expect(log.size).to eq(1)
    expect(log.last.message).to eq(input_entry.message)
  end

  it "adds context" do
    expect(log.last.context).to eq(extra_context)
  end

  context "when there is existing context in the entry" do

    let(:input_context) do
      { thread: "bg", user: "bob" }.freeze
    end

    it "retains existing context" do
      expect(log.last.context[:user]).to eq(input_context[:user])
    end

    it "adds missing context" do
      expect(log.last.context[:pid]).to eq(extra_context[:pid])
    end

    it "favours what's in the entry" do
      expect(log.last.context[:thread]).to eq(input_context[:thread])
    end

  end

end
