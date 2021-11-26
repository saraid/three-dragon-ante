module ThreeDragonAnte
  class Game
    class Gambit
      class PlayerAnte
        def initialize(card)
          @card = card
          @revealed = false
        end
        attr_reader :card

        def revealed?
          @revealed
        end

        def reveal!
          @revealed = true
        end
      end
    end
  end
end
