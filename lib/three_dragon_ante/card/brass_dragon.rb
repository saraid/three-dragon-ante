module ThreeDragonAnte
  class Card
    class BrassDragon < Card
      def initialize(strength)
        super('Brass Dragon', %i( good dragon ), strength)
      end

      manipulates_hands!
      manipulates_hoards!

      def trigger_power!(gambit, player)
        opponent, _flight = gambit.flights.reject { _1 == player }.max_by { _2.strength }
        opponent.choose_one(:pay_me_5_gold, :give_stronger_good_dragon) do |first_choice|
          case first_choice
          when :give_stronger_good_dragon
            next if player.hand.size >= Game::Player::MAX_HAND_SIZE
            opponent.generate_choice_from_hand(
              prompt: :choose_to_give, only: proc { _1.good_dragon? && _1.strength > strength}
            ) { |second_choice| player.hand << (opponent.hand >> second_choice) }
          when :pay_me_5_gold
            cash = opponent.hoard.lose(5, to: player)
            player.hoard.gain cash
          end
        end
      end
    end
  end
end


