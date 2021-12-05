module ThreeDragonAnte
  class Game
    class Event
      class AnteChanged < ArrayChanged
        def inspect
          [:ante, operation, affected_item].inspect
        end
      end
    end
  end
end
