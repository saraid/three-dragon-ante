module ThreeDragonAnte
  class Game
    class Event
      class PlayerHoardChanged < IntegerChanged
        def self.[](player)
          proc { new(_1, _2, _3, player: player) }
        end

        def initialize(*args, player:)
          super(*args)
          @player = player
        end

        def inspect
          [@player.identifier, :hoard, operation, affected_item, :new_value, new_value].inspect
        end
      end
    end
  end
end
