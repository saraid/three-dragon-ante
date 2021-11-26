module ThreeDragonAnte
  class Game
    class Player
      class Hoard
        def initialize
          @value = 0
        end
        attr_reader :value

        def gain(num)
          @value += num
        end

        def lose(num)
          @value -= num
        end
      end
    end
  end
end
