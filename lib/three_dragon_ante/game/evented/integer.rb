require 'forwardable'

module ThreeDragonAnte
  class Game
    module Evented
      class Integer
        extend Forwardable

        #def_delegators :@value

        def initialize(game, can_become_negative: false, &block)
          @game = game
          @can_become_negative = can_become_negative
          @value = 0
          @describer = block if block_given?
        end
        attr_reader :game
        attr_reader :value

        def describe(operation, other)
          raise NotImplementedError unless @describer
          @describer.call(operation, other).concat([:new_value, @value])
        end

        def gain(other)
          @value += other
          game << describe(:gain, other)
          other
        end

        def lose(other)
          difference = [other, @value].min
          @value -= other
          @value = 0 if @value < 0 && !@can_become_negative
          difference.tap { game << describe(:lose, other) }
        end
      end
    end
  end
end
