module ThreeDragonAnte
  class Game
    class Event
      class ChoiceOffered < Event::Details
        def initialize(current_choices, to:)
          @player, @choice = to, current_choices.last
          @choices_pending = current_choices.size
        end
        attr_reader :player, :choice, :choices_pending

        def inspect
          [player.identifier, :offered_choice, choice, choices_pending].inspect
        end
      end
    end
  end
end
