require_relative 'hoard/debt'

module ThreeDragonAnte
  class Game
    class Player
      class Hoard < Evented::Integer
        def initialize(game, player, &block)
          super(game) { [player, _1, :hoard, _2] }
          @game = game
          @debts = Evented::Array.new(game) { [player, :debts, _1, _2] }
        end
        attr_reader :debts

        def gain(other)
          amount = other
          @debts.each do |debt|
            payable = [amount, debt.value].min
            return if payable <= 0 # if a debt exists && you have nothing left to pay with: no gain

            debt.pay payable
            amount -= payable
            @debts >> debt if debt.value.zero?
          end
          super(amount)
        end

        def lose(other, to: nil)
          current = @value
          remainder = super(other)
          debt = other - current
          @debts << Debt.new(@game, debt, to) if debt > 0 && !to.nil?
          remainder
        end
      end
    end
  end
end
