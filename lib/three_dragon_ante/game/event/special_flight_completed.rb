module ThreeDragonAnte
  class Game
    class Event
      class SpecialFlightCompleted < Event::Details
        def initialize(player, type, flight)
          @player, @type, @flight = player, type, flight
        end
        attr_reader :player, :type, :flight

        def inspect
          [player.identifier, :completed_special_flight, @type, @flight].inspect
        end
      end
    end
  end
end

