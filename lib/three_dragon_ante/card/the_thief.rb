module ThreeDragonAnte
  class Card
    class TheThief < Card
      def initialize
        super('The Thief', %i( mortal ), 7)
      end

      manipulates_hands!
      manipulates_hoards!
      manipulates_stakes!

      def trigger_power!(gambit, player)
        cash = gambit.stakes.lose 7
        player.hoard.gain cash

        player.generate_choice_from_hand(prompt: :discard_one) do |choice|
          gambit.game.deck.discarded(player.hand >> choice)
        end
      end
    end
  end
end
