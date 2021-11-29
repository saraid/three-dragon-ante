module ThreeDragonAnte
  class Game
    class Event
      class ChoiceMade < Event::Details
        def initialize(chosen_option, by:)
          @player, @chosen = by, chosen_option
        end
        attr_reader :player, :chosen

        def inspect
          [player.identifier, :made_choice, chosen].inspect
        end
      end
    end
  end
end
