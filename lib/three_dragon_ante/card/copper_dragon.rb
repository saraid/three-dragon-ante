module ThreeDragonAnte
  class Card
    class CopperDragon < Card
      def initialize(strength)
        super('Copper Dragon', %i( good dragon ), strength)
      end

      manipulates_everything!

      def trigger_power!(gambit, player)
        replacement = gambit.game.deck.draw!
        gambit.flights[player] >> self
        gambit.flights[player] << replacement
        replacement.trigger_power!(gambit, player)
      end
    end
  end
end




