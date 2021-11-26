module ThreeDragonAnte
  class Game
    class Player
      class Choice
        def initialize(choices)
          @choices = choices
        end
        attr_reader :choices
      end
    end
  end
end
