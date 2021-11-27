module ThreeDragonAnte
  class Card
    class BlueDragon < Card
      def initialize(strength)
        super('Blue Dragon', %i( evil dragon ), strength)
      end

      def trigger_power!(gambit, player)
        gambit.game << Choice.new(:choose_one, [ :steal_per_evil_dragon, :others_pay_per_evil_dragon ]) do |choice|
          evil_dragons = gambit.flights[player].select(&:evil?).size

          case choice
          when :steal_per_evil_dragon
            cash = gambit.stakes.lose evil_dragons
            player.hoard.gain cash
          when :others_pay_per_evil_dragon
            gambit.players.each do |opponent|
              cash = opponent.hoard.lose
              gambit.stakes.gain cash
            end
          end
        end
      end
    end
  end
end

