module ThreeDragonAnte
  class Card
    class WhiteDragon < Card
      def initialize(strength)
        super('White Dragon', %i( evil dragon ), strength)
      end

      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        if gambit.flights.values.any? { _1.any?(&:mortal?) }
          cash = gambit.stakes.lose 3
          player.hoard.gain cash
        end
      end
    end
  end
end








