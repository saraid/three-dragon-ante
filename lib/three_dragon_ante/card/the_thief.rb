module ThreeDragonAnte
  class Card
    class TheThief < Card
      def initialize
        super('The Thief', %i( mortal ), 7)
      end

      def trigger_power!(gambit, player)
        cash = gambit.stakes.lose 7
        player.hoard.gain cash

        player.generate_choice_from_hand(prompt: :discard_one) do |choice|
          player.hand >> choice
        end
      end
    end
  end
end
