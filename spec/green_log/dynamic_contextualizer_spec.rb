# frozen_string_literal: true

require "green_log/dynamic_contextualizer"
require "green_log/entry"

RSpec.describe GreenLog::DynamicContextualizer do

  let(:log) { [] }

  let(:input_entry) do
    GreenLog::Entry.with(message: "Hello", context: {})
  end

  subject(:contextualizer) do
    described_class.new(log) do
      {
        random_detail: rand
      }
    end
  end

  before do
    contextualizer << input_entry
    contextualizer << input_entry
  end

  it "passes entries downstream" do
    expect(log.size).to eq(2)
    expect(log.last.message).to eq(input_entry.message)
  end

  it "adds context" do
    expect(log.last.context).to include(random_detail: a_kind_of(Float))
  end

end
