module ThreeDragonAnte
  class Game
    class Gambit
      class Round
        def initialize(gambit)
          @game = gambit.game
          @gambit = gambit
        end
        attr_reader :game, :gambit

        def run
          game.players.each do |player|
            player.generate_choice_from_hand do |choice|
              gambit.flights[player] << choice
              choice.trigger_power!
            end
          end
        end
      end
    end
  end
end
