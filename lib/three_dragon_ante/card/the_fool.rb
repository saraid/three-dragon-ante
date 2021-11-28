module ThreeDragonAnte
  class Card
    class TheFool < Card
      def initialize
        super('The Fool', %i( mortal ), 3)
      end

      manipulates_hands!
      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        current_flight_strength = gambit.flights[player].strength
        gambit.flights.select { |p, flight| flight.strength > current_flight_strength }.size.times do
          player.draw_card!
        end
      end
    end
  end
end
