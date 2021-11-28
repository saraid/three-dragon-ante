module ThreeDragonAnte
  class Game
    class Player
      class Hoard < Evented::Integer
        class Debt < Evented::Integer
          include Refinements::Inspection

          def initialize(game, amount, player)
            super(game) { [:debt, player, _1, _2] }
            @amount, @player = amount, player
            gain(amount)
          end
          attr_reader :player

          def inspectable_attributes
            %i( player )
          end

          def pay(amount)
            return if amount <= 0
            player.hoard.gain amount
            lose(amount)
          end
        end
      end
    end
  end
end

