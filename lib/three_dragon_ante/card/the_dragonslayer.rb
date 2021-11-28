module ThreeDragonAnte
  class Card
    class TheDragonslayer < Card
      def initialize
        super('The Dragonslayer', %i( mortal ), 8)
      end

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        options = gambit.flights.map do |player, flight|
          flight.values.map { |card| [player, card] if card.dragon? }.compact
        end.flatten(1)

        player.choose_one(*options, prompt: :slay) do |choice|
          owner, dragon = choice
          gambit.flights[owner] >> dragon
        end
      end
    end
  end
end
