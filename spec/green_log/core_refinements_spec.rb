# frozen_string_literal: true

require "green_log/core_refinements"

RSpec.describe GreenLog::CoreRefinements do

  using GreenLog::CoreRefinements

  describe Hash do

    describe "#to_loggable" do

      let(:hash) { { host: "foo.example.com", pid: 123 } }

      it "returns a frozen Hash" do
        expect(hash.to_loggable).to be_frozen
      end

    end

    describe "#integrate" do

      it "merges deeply" do
        original = {
          author: {
            name: "Jim"
          }
        }
        new_data = {
          author: {
            age: 42
          }
        }
        expect(original.integrate(new_data)).to eq(
          author: {
            name: "Jim",
            age: 42
          }
        )
      end

      it "favours new data" do
        original = {
          hockey: 1
        }
        new_data = {
          hockey: 2
        }
        expect(original.integrate(new_data)).to eq(
          hockey: 2
        )
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

  describe String do

    describe "#to_loggable" do

      it "returns a frozen duplicate" do
        original = "Hello, world!".dup
        result = original.to_loggable
        expect(result).to eq(original)
        expect(result).to be_frozen
        expect(original).to_not be_frozen
      end

    end

  end

end
