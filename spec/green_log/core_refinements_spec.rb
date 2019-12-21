# frozen_string_literal: true

require "green_log/core_refinements"

RSpec.describe GreenLog::CoreRefinements do

  using GreenLog::CoreRefinements

  describe Hash do

    describe "#to_loggable" do

      it "symbolizes keys" do
        input = { "x" => 42 }
        expect(input.to_loggable).to eq(x: 42)
      end

    end

  end

end
