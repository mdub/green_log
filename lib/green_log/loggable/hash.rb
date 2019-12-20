# frozen_string_literal: true

require "green_log/loggable/conversions"

module GreenLog

  module Loggable

    # A type of immutable Hash suitable for holding loggable data.
    class Hash

      using Loggable::Conversions

      def initialize(data = {})
        @entries = {}
        data.each do |k, v|
          entries[k.to_loggable_key] = v.to_loggable_value
        end
        @entries.freeze
      end

      attr_reader :entries

      def empty?
        entries.empty?
      end

      def to_h
        {}.tap do |result|
          entries.each do |k, v|
            result[k] = v.to_ruby_data
          end
        end
      end

      def merge(other_data)
        other_data = other_data.to_loggable_value
        merged_data = entries.merge(other_data.entries) do |_key, old, new|
          if old.is_a?(Loggable::Hash) && new.is_a?(Loggable::Hash)
            old.merge(new)
          else
            new
          end
        end
        self.class.new(merged_data)
      end

      def to_loggable_value
        self
      end

      alias to_ruby_data to_h

    end

  end

end
