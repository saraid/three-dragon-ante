module ThreeDragonAnte
  class Card
    class BlueDragon < Card
      def initialize(strength)
        super('Blue Dragon', %i( evil dragon ), strength)
      end

      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        player.choose_one(:steal_from_stakes, :others_pay_into_stakes) do |choice|
          evil_dragons = gambit.flights[player].select(&:evil?).size

          case choice
          when :steal_from_stakes
            cash = gambit.stakes.lose evil_dragons
            player.hoard.gain cash
          when :others_pay_into_stakes
            gambit.players.except(player).each do |opponent|
              cash = opponent.hoard.lose evil_dragons
              gambit.stakes.gain cash
            end
          end
        end
      end
    end
  end
end

