require_relative 'player/choice'
require_relative 'player/hoard'

module ThreeDragonAnte
  class Game
    class Player
      include Refinements::Inspection

      def initialize(game)
        @game = game
        @hoard = Evented::Integer.new(game) { [_1, :hoard, _2] }
        @hand = Evented::SetOfCards.new(game)
      end
      attr_reader :game
      attr_accessor :identifier
      attr_reader :hoard, :hand

      def current_choice
        @choice
      end

      def custom_inspection
        " #{@identifier}"
      end

      def generate_choice_from_hand(&block)
        on_choice = proc do |choice|
          @game << [:choose, self, choice]
          block.call(choice)
        end

        @game << @choice = Choice.new(@hand.values, &on_choice)
      end
    end
  end
end
