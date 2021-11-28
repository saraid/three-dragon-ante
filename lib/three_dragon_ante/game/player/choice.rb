require_relative 'choice/array'

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

        def choose!(choice_or_index)
          @resolved = true
          case choice_or_index
          when NilClass then @on_fail.call
          when Integer then @on_choice.call(@choices[choice_or_index])
          else
            raise ArgumentError unless @choices.include?(choice_or_index)
            @on_choice.call(choice_or_index)
          end
        end

        def resolved?
          @resolved
        end
      end
    end
  end
end
