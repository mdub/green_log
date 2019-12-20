# frozen_string_literal: true

module GreenLog

  module Loggable

    # Type conversion refinements.
    module Conversions

      refine ::Array do

        def to_loggable_value
          raise ArgumentError, "arrays not supported here"
        end

      end

      refine ::Hash do

        def to_loggable_value
          Loggable::Hash.new(self)
        end

      end

      refine ::Object do

        def to_ruby_data
          self
        end

        def to_loggable_value
          self
        end

      end

      refine ::String do

        def to_loggable_key
          to_sym
        end

      end

      refine ::Symbol do

        def to_loggable_key
          self
        end

      end

    end

  end

end
