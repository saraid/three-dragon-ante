module ThreeDragonAnte
  class Game
    class Player
      class Choice
        class Array
          def initialize
            @values = []
          end

          def respond_to_missing?(id, include_private = false)
            @values.respond_to_missing?(id, include_private)
          end

          def method_missing(id, *args, &block)
            flush!
            @values.send(id, *args, &block)
          end

          private
          def flush!
            @values.reject!(&:resolved?)
          end
        end
      end
    end
  end
end
