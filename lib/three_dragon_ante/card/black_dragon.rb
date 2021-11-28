module ThreeDragonAnte
  class Card
    class BlackDragon < Card
      def initialize(strength)
        super('Black Dragon', %i( evil dragon ), strength)
      end

      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        cash = gambit.stakes.lose 2
        player.hoard.gain cash
      end
    end
  end
end
