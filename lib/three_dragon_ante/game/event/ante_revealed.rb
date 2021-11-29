module ThreeDragonAnte
  class Game
    class Event
      class AnteRevealed < Event::Details
        def initialize(ante)
          @ante = ante
        end
        attr_reader :ante

        def inspect
          [:ante, :revealed, *@ante.map { { _1.player.identifier => _1.card } }].inspect
        end
      end
    end
  end
end
