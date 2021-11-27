module ThreeDragonAnte
  class Game
    module Evented
      class SetOfCards < Array
        def describe(operation, other)
          raise TypeError unless Card === other
          context = @describer.call if @describer
          [*context, operation, other]
        end

        def strength
          @values.map(&:strength).reduce(0, :+)
        end
      end
    end
  end
end
