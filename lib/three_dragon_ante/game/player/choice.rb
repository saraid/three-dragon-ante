module ThreeDragonAnte
  class Game
    class Player
      class Choice
        include Refinements::Inspection

        def initialize(choices, &block)
          @choices = choices
          @on_choice = block
        end
        attr_reader :choices
        
        def inspectable_attributes
          %i( choices )
        end

        def custom_inspection
          " #{@choices.size} choices"
        end

        def choose!(index)
          @on_choice.call(@choices.index(index))
        end
      end
    end
  end
end
