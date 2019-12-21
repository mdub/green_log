# frozen_string_literal: true

module GreenLog

  # Refine
  module CoreRefinements

    refine ::Hash do

      def to_loggable
        {}.tap do |result|
          each do |k, v|
            result[k.to_sym] = v.to_loggable
          end
        end.freeze
      end

      def integrate(other)
        other = other.to_hash
        merge(other) do |_key, old_value, new_value|
          if old_value.is_a?(Hash) && new_value.is_a?(Hash)
            old_value.integrate(new_value)
          else
            new_value
          end
        end
      end

    end

    refine ::Numeric do

      def to_loggable
        self
      end

    end

    refine ::String do

      def to_loggable
        frozen? ? self : dup.freeze
      end

    end

    refine ::NilClass do

      def to_loggable
        self
      end

    end

    refine ::TrueClass do

      def to_loggable
        self
      end

    end

    refine ::FalseClass do

      def to_loggable
        self
      end

    end

  end

end
