module ThreeDragonAnte
  class Game
    module Evented
      class SetOfCards < Array
        include Refinements::Inspection

        def describe(operation, other)
          raise TypeError unless Card === other
          context = @describer.call if @describer
          [*context, operation, other]
        end

        def inspectable_attributes
          %i( values )
        end

        def strength
          @values.map(&:strength).reduce(0, :+)
        end
      end
    end
  end
end
