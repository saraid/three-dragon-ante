require_relative 'player/choice'
require_relative 'player/hoard'

module ThreeDragonAnte
  class Game
    class Player
      include Refinements::Inspection

      MAX_HAND_SIZE = 10
      STARTING_HAND_SIZE = 6
      STARTING_HOARD_SIZE = 50

      def initialize(game)
        @game = game
        @hoard = Hoard.new(game, self)
        @hand = Evented::SetOfCards.new(game) { [:player_hand, identifier] }
        @choices = Choice::Array.new
      end
      attr_reader :game
      attr_writer :identifier
      attr_reader :hoard, :hand

      def identifier
        @identifier || object_id # TODO
      end

      def current_choice
        @choices.first
      end

      def custom_inspection
        " #{@identifier}"
      end

      def generate_choice_from_hand(prompt:, only: :itself.to_proc, &block)
        on_choice = proc do |choice|
          @game << [:choose, self, choice]
          block.call(choice)
        end

        @game << [identifier, :choice, @choices << Choice.new(prompt, @hand.values.select(&only), &on_choice), @choices.size]
      end

      def choose_one(*choices, prompt: :choose_one, &block)
        on_choice = proc do |choice|
          @game << [:choose, self, choice]
          block.call(choice)
        end

        @game << [identifier, :choice, @choices << Choice.new(prompt, choices, &on_choice), @choices.size]
      end

      def draw_card(deck)
        hand << deck.draw! unless hand.size >= MAX_HAND_SIZE
      end
    end
  end
end
