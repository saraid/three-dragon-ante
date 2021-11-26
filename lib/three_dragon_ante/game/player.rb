require_relative 'player/choice'

module ThreeDragonAnte
  class Game
    class Player
      def initialize
        @hoard = 0
        @hand = []
      end
      attr_reader :hoard, :hand

      def current_choice
        @choice
      end

      def generate_choice_from_hand
        @choice = Choice.new(@hand)
      end
    end
  end
end
