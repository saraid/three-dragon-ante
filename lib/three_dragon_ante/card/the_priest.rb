module ThreeDragonAnte
  class Card
    class ThePriest < Card
      def initialize
        super('The Priest', %i( mortal ), 5)
      end

      manipulates_turn_order!
      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        gambit.temporary_leader = player
      end
    end
  end
end
