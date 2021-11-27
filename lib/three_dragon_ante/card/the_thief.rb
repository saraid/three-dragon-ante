module ThreeDragonAnte
  class Card
    class TheThief < Card
      def initialize
        super('The Thief', %i( mortal ), 7)
      end

      def trigger_power!(gambit, player)
        cash = gambit.stakes.lose 7
        player.hoard.gain cash

        # player discards a card
      end
    end
  end
end
