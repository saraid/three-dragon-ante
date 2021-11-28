module ThreeDragonAnte
  class Card
    class Bahamut < Card
      def initialize
        super('Bahamut', %i( good dragon god ), 13)
      end

      def trigger_power!(gambit, player)
        opponents = gambit.flights.select do |opponent, flight|
          next if opponent == player
          flight.any?(&:good?) && flight.any?(&:evil?)
        end.keys

        opponents.each do |opponent|
          cash = opponent.hoard.lose(10, to: player)
          player.hoard.gain cash
        end
      end
    end
  end
end
