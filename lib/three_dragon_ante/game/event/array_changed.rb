module ThreeDragonAnte
  class Game
    class Event
      class ArrayChanged < Event::Details
        def initialize(operation, affected_item)
          @operation, @affected_item = operation, affected_item
        end
        attr_reader :operation, :affected_item

        def inspect
          [operation, affected_item].inspect
        end
      end
    end
  end
end
