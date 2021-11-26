module ThreeDragonAnte
  class Game
    class Gambit
      class PlayerAnte
        def initialize(player, card)
          @player, @card = player, card
        end
        attr_reader :player, :card
      end
    end
  end
end
