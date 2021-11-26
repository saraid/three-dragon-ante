require_relative 'player/choice'
require_relative 'player/hoard'

module ThreeDragonAnte
  class Game
    class Player
      include Refinements::Inspection

      def initialize(game)
        @game = game
        @hoard = Evented::Integer.new(game) { [_1, :hoard] }
        @hand = Evented::SetOfCards.new(game)
      end
      attr_reader :game
      attr_reader :hoard, :hand

      def current_choice
        @choice
      end

      def generate_choice_from_hand(&block)
        @game << @choice = Choice.new(@hand.values, &block)
      end
    end
  end
end
