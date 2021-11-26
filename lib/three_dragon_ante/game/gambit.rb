require_relative 'gambit/player_ante'

module ThreeDragonAnte
  class Game
    class Gambit
      def initialize(game)
        @game = game
        @ante = {}

        @stakes = 0
      end
      attr_reader :game

      def ended?
        false
      end

      def players
        game.players
      end

      def run
        accept_ante
        reveal_ante

        play_cards

        win_stakes
      end

      def accept_ante
        players.each do |player|
          player.generate_choice_from_hand do |choice|
            @ante[player] = PlayerAnte.new(choice)
          end
        end
      end

      def reveal_ante
        @ante.values.each(&:reveal!)

        choose_leader
        pay_stakes
      end

      def choose_leader
      end

      def pay_stakes
      end

      def play_cards
      end

      def win_stakes
      end
    end
  end
end
