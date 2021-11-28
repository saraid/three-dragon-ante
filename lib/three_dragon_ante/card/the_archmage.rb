module ThreeDragonAnte
  class Card
    class TheArchmage < Card
      def initialize
        super('The Archmage', %i( mortal ), 9)
      end

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        player.choose_one(*gambit.ante.values, prompt: :copy_ante_power) do |choice|
          choice.method(:trigger_power!).bind(self).call(gambit, player)
        end
      end
    end
  end
end
