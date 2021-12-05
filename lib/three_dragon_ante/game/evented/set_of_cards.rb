module ThreeDragonAnte
  class Game
    module Evented
      class SetOfCards < Array
        include Refinements::Inspection

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
