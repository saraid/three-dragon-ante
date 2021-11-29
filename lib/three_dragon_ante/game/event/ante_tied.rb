module ThreeDragonAnte
  class Game
    class Event
      class AnteTied < Event::Details
        def initialize
        end

        def inspect
          [:tied].inspect
        end
      end
    end
  end
end

