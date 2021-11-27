module ThreeDragonAnte
  class Game
    class Player
      class Choice
        include Refinements::Inspection

        def initialize(prompt, choices, &block)
          @prompt, @choices = prompt, choices
          @resolved = false
          @on_choice = block
        end
        attr_reader :prompt, :choices
        
        def inspectable_attributes
          %i( prompt choices )
        end

        def custom_inspection
          " #{@choices.size} choices"
        end

        def choose!(index)
          @on_choice.call(@choices[index])
          @resolvd = true
        end

        def resolved?
          @resolved
        end
      end
    end
  end
end
