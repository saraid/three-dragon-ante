module ThreeDragonAnte
  class Card
    class GoldDragon < Card
      def initialize(strength)
        super('Gold Dragon', %i( good dragon ), strength)
      end

      manipulates_hands!

      def trigger_power!(gambit, player)
        gambit.flights[player].select(&:good?).size.times do
          player.draw_card!
        end
      end
    end
  end
end





