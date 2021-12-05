module ThreeDragonAnte
  class Game
    class Event
      class GambitStakesChanged < IntegerChanged
        def inspect
          [:stakes, operation, affected_item, :new_value, new_value].inspect
        end
      end
    end
  end
end
