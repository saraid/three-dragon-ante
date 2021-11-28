require_relative 'hoard/debt'

module ThreeDragonAnte
  class Game
    class Player
      class Hoard < Evented::Integer
        def initialize(game, player, &block)
          super(game) { [_1, :hoard, _2] }
          @game = game
          @debts = Evented::Array.new(game) { [:debts, player, _1, _2] }
        end
        attr_reader :debts

        def gain(other)
          amount = other
          @debts.reject! do |debt|
            payable = [[amount, debt.value].min, 0].max
            debt.pay payable
            amount -= payable
            debt.value.zero?
          end
          super(amount)
        end

        def lose(other, to: nil)
          current = @value
          remainder = super(other)
          debt = current - @value
          @debts << Debt.new(@game, debt, to) if debt > 0 && !to.nil?
          remainder
        end
      end
    end
  end
end
