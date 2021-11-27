module ThreeDragonAnte
  class Game
    class Player
      class Hoard < Evented::Integer
        def initialize(game, &block)
          super(game, can_become_negative: true) { [_1, :hoard, _2] }
          @debts = {}
        end
        attr_reader :debts

        def lose(other, to: nil)
          current = @value
          remainder = super(other)
          debt = @value - current
          add_debt(debt, to) if debt > 0
          remainder
        end

        def add_debt(debt, to)
          @debts[to] ||= 0
          @debts[to] += debt
        end
      end
    end
  end
end
