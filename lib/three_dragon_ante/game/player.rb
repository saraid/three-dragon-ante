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
        @hand = Evented::SetOfCards.new(game, &Event::PlayerHandChanged[self])
        @choices = Choice::Array.new
      end
      attr_reader :game
      attr_writer :identifier
      attr_reader :hoard, :hand

      def identifier
        @identifier ||=
          begin
            require 'securerandom'
            SecureRandom.hex(6).to_sym
          end
      end

      def current_choice
        @choices.first
      end

      def custom_inspection
        " #{@identifier}"
      end

      def generate_choice_from_hand(prompt:, only: :itself.to_proc, &block)
        on_choice = proc do |choice|
          @game << Event::ChoiceMade[choice, by: self]
          block.call(choice)
        end

        @game << Event::ChoiceOffered[@choices << Choice.new(prompt, @hand.values.select(&only), &on_choice), to: self]
      end

      def choose_one(*choices, prompt: :choose_one, &block)
        on_choice = proc do |choice|
          @game << Event::ChoiceMade[choice, by: self]
          block.call(choice)
        end

        @game << Event::ChoiceOffered[@choices << Choice.new(prompt, choices, &on_choice), to: self]
      end

      def draw_card!(deck = game.deck)
        hand << deck.draw! unless hand.size >= MAX_HAND_SIZE
      end

      def buy_cards!(deck = game.deck)
        top_card = deck.draw!
        deck.discarded(top_card)

        draw_card!(deck) until hand.size >= 4
      end
    end
  end
end
