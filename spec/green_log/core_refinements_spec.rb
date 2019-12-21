# frozen_string_literal: true

require "green_log/core_refinements"

RSpec.describe GreenLog::CoreRefinements do

  using GreenLog::CoreRefinements

  describe Hash do

    let(:hash) { { host: "foo.example.com", pid: 123 } }

    describe "#to_loggable" do
      it "returns a frozen Hash" do
        expect(hash.to_loggable).to be_frozen
      end
    end

    context "with String keys" do

      let(:hash) do
        {
          "x" => 42,
          "a" => { "b" => "c" }
        }
      end

      describe "#to_loggable" do

        it "symbolizes the keys" do
          expect(hash.to_loggable).to eq(
            x: 42,
            a: {
              b: "c"
            }
          )
        end

      end

    end

  end

end
