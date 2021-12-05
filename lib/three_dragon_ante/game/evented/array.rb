require 'forwardable'

module ThreeDragonAnte
  class Game
    module Evented
      class Array
        extend Forwardable
        include Enumerable

        def_delegators :@values, :size, :each, :[], :index, :sample, :reject!, :empty?

        def initialize(game, &block)
          @game = game
          @values = []
          @describer = block if block_given?
        end
        attr_reader :game
        attr_reader :values

        def describe(operation, other)
          raise NotImplementedError unless @describer
          @describer.call(operation, other)
        end

        def dup
          self.class.new(game, &@describer).tap do |duped|
            duped.instance_variable_set(:@values, @values.dup)
          end
        end

        def <<(other)
          game << describe(:gain, other)
          @values << other
        end

        def >>(other)
          game << describe(:lose, other)
          @values.delete(other)
        end

        def except(item)
          @values.dup.tap { _1.delete(item) }
        end
      end
    end
  end
end
