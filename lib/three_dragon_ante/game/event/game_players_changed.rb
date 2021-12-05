module ThreeDragonAnte
  class Game
    class Event
      class GamePlayersChanged < ArrayChanged
        def inspect
          [:players, operation, affected_item].inspect
        end
      end
    end
  end
end
