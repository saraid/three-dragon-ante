module ThreeDragonAnte
  class Game
    class Event
      class IntegerChanged < Event::Details
        def initialize(operation, affected_item, new_value)
          @operation, @affected_item, @new_value = operation, affected_item, new_value
        end
        attr_reader :operation, :affected_item, :new_value

        def inspect
          [operation, affected_item, :new_value, new_value].inspect
        end
      end
    end
  end
end
