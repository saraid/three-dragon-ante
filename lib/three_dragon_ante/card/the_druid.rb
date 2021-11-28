module ThreeDragonAnte
  class Card
    class TheDruid < Card
      def initialize
        super('The Druid', %i( mortal ), 6)
      end

      manipulates_gambit_outcome!
      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash
      end
    end
  end
end
