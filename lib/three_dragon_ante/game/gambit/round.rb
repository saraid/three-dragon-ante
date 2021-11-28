module ThreeDragonAnte
  class Game
    class Gambit
      class Round
        def initialize(gambit, leader)
          @game = gambit.game
          @gambit = gambit
          @cards_played = []

          player_order = game.players.dup
          player_order.rotate! until player_order.first == leader
          @player_order = player_order.to_enum

          @current_player = @player_order.next
          @last_played_strength = 0
        end
        attr_reader :game, :gambit
        attr_reader :current_player, :cards_played

        def started?
          @cards_played.size > 0
        end

        def ended?
          @cards_played.size == game.players.size
        end

        def run
          current_player.generate_choice_from_hand(prompt: :play_card) do |choice|
            @cards_played << PlayerChoice.new(current_player, current_player.hand >> choice)
            gambit.flights[current_player] << choice
            choice.trigger_power!(gambit, current_player) if choice.strength > @last_played_strength

            if ThreeDragonAnte::Card::CopperDragon === choice
              @last_played_strength = gambit.flights[current_player].values.last.strength
            else
              @last_played_strength = choice.strength
            end
          end
        end

        def next_player
          @current_player = @player_order.next unless ended?
        end

        def advance
          next_player
          run
        end

        # new players join to the left of the last
        # yes it's counterintuitive
        def player_left_of_current
          @player_order.peek
        end

        def players_leftward_from_current
          player_order = game.players.dup
          player_order.rotate! until player_order.first == @current_player
          player_order
        end
      end
    end
  end
end
