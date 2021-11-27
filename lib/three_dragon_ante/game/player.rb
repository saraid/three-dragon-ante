require_relative 'player/choice'
require_relative 'player/hoard'

module ThreeDragonAnte
  class Game
    class Player
      include Refinements::Inspection

      MAX_HAND_SIZE = 10

      def initialize(game)
        @game = game
        @hoard = Hoard.new(game)
        @hand = Evented::SetOfCards.new(game) { [:player_hand, identifier] }
      end
      attr_reader :game
      attr_writer :identifier
      attr_reader :hoard, :hand

      def identifier
        @identifier || object_id # TODO
      end

      def current_choice
        @choice
      end

      def custom_inspection
        " #{@identifier}"
      end

      def generate_choice_from_hand(prompt:, only: :itself.to_proc, &block)
        on_choice = proc do |choice|
          @game << [:choose, self, choice]
          block.call(choice)
        end

        @game << @choice = Choice.new(prompt, @hand.values.select(&only), &on_choice)
      end

      def draw_card(deck)
        hand << deck.draw! unless hand.size >= MAX_HAND_SIZE
      end

      def <<(choice)
        @game << @choice = choice
      end
    end
  end
end
