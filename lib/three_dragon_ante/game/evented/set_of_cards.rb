module ThreeDragonAnte
  class Game
    module Evented
      class SetOfCards < Array
        def describe(operation, other)
          raise TypeError unless Card === other
          context = @describer.call if @describer
          [*context, operation, other]
        end
      end
    end
  end
end
