module ThreeDragonAnte
  class Game
    class Event
      class PlayerHoardDebtsChanged < ArrayChanged
        def self.[](player)
          proc { new(_1, _2, player: player) }
        end

        def initialize(*args, player:)
          super(*args)
          @player = player
        end

        def inspect
          [@player.identifier, :debts, operation, affected_item].inspect
        end
      end
    end
  end
end

