module ThreeDragonAnte
  class Game
    class Gambit
      class Round
        def initialize(gambit)
          @game = gambit.game
          @gambit = gambit
          @cards_played = []

          player_order = game.players.dup
          player_order.rotate! until player_order.first == gambit.leader
          @player_order = player_order.to_enum

          @current_player = @player_order.next
        end
        attr_reader :game, :gambit
        attr_reader :current_player

        def ended?
          gambit.over? || @cards_played.size == game.players.size
        end

        def run
          current_player.generate_choice_from_hand(prompt: :play_card) do |choice|
            @cards_played << [current_player, choice]
            gambit.flights[current_player] << choice
            choice.trigger_power!(gambit, current_player)
          end
        end

        def next
          @current_player = @player_order.next
        end
      end
    end
  end
end
