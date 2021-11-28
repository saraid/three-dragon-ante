module ThreeDragonAnte
  class Card
    class RedDragon < Card
      def initialize(strength)
        super('Red Dragon', %i( evil dragon ), strength)
      end

      def trigger_power!(gambit, player)
        opponent, flight = gambit.flights.reject { player == _1 }.max_by { _2.strength }

        player.hoard.gain(opponent.hoard.lose(1, to: player))
        player.hand << (opponent.hand >> opponent.hand.sample)
      end
    end
  end
end







