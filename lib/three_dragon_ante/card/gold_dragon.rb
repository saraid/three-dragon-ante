module ThreeDragonAnte
  class Card
    class GoldDragon < Card
      def initialize(strength)
        super('Gold Dragon', %i( good dragon ), strength)
      end

      def trigger_power!(gambit, player)
        gambit.flights[player].select(&:good?).size.times do
          player.draw_card(gambit.game.deck)
        end
      end
    end
  end
end





