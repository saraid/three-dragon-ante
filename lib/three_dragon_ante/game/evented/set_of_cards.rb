module ThreeDragonAnte
  class Game
    module Evented
      class SetOfCards < Array
        def describe(operation, other)
          raise TypeError unless Card === other
          [operation, other.inspect]
        end
      end
    end
  end
end
