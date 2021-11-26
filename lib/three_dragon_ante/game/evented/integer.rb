require 'forwardable'

module ThreeDragonAnte
  class Game
    module Evented
      class Integer
        extend Forwardable

        #def_delegators :@value

        def initialize(game, &block)
          @game = game
          @value = 0
          @describer = block if block_given?
        end
        attr_reader :game
        attr_reader :value

        def describe(operation, other)
          raise NotImplementedError unless @describer
          @describer.call(operation, other)
        end

        def gain(other)
          game << describe(:gain, other)
          @value += other
        end

        def lose(other)
          game << describe(:lose, other)
          @value -= other
        end
      end
    end
  end
end
