module ThreeDragonAnte
  class Game
    class Event
      class LeaderChosen < Event::Details
        def initialize(player)
          @player = player
        end
        attr_reader :player

        def inspect
          [:leader, @player.identifier].inspect
        end
      end
    end
  end
end

