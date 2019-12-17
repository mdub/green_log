# frozen_string_literal: true

module GreenLog

  module Loggable

    # A type of immutable Hash suitable for holding loggable data.
    class Hash

      def initialize(data = {})
        @data = data.transform_keys(&:to_sym)
        @data.freeze
      end

      attr_reader :data

      def empty?
        data.empty?
      end

      def to_h
        data.to_h
      end

    end

  end

end
