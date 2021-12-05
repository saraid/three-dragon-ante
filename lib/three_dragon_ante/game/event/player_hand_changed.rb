module ThreeDragonAnte
  class Game
    class Event
      class PlayerHandChanged < ArrayChanged
        def self.[](player)
          proc { new(_1, _2, player: player) }
        end

        def initialize(*args, player:)
          super(*args)
          @player = player
        end

        def inspect
          [@player.identifier, :player_hand, operation, affected_item].inspect
        end
      end
    end
  end
end
