module ThreeDragonAnte
  class Card
    class ThePrincess < Card
      def initialize
        super('The Princess', %i( mortal ), 4)
      end

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        options = gambit.flights[player].values.select(&:good_dragon?).yield_self do |flight|
          flight.permutation(flight.size)
        end

        player.choose_one(*options) do |choice|
          choice.each { _1.trigger_power!(gambit, player) }
        end
      end
    end
  end
end
