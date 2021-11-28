module ThreeDragonAnte
  class Card
    class TheArchmage < Card
      def initialize
        super('The Archmage', %i( mortal ), 9)
      end

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        player.choose_one(*gambit.ante.values.map(&:class), prompt: :copy_ante_power) do |choice|
          build_copy(choice, strength).trigger_power!(gambit, player)
        end
      end
    end
  end
end
