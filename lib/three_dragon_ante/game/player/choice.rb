module ThreeDragonAnte
  class Game
    class Player
      class Choice
        include Refinements::Inspection

        def initialize(prompt, choices, on_fail: Proc.new { nil }, &block)
          @prompt, @choices = prompt, choices
          @resolved = false
          @on_fail = proc { @resolved = true } >> on_fail
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
          if index.nil? then @on_fail.call
          else @on_choice.call(@choices[index])
          end
          @resolved = true
        end

        def resolved?
          @resolved
        end
      end
    end
  end
end
