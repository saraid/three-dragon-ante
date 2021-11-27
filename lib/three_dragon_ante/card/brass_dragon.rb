module ThreeDragonAnte
  class Card
    class BrassDragon < Card
      def initialize(strength)
        super('Brass Dragon', %i( good dragon ), strength)
      end

      def trigger_power!(gambit, player)
        opponent, _flight = gambit.flights.reject { _1 == player }.max_by { _2.strength }
        opponent << Game::Player::Choice.choose_one(:give_stronger_good_dragon, :pay_me_5_gold) do |first_choice|
          case first_choice
          when :give_stronger_good_dragon
            next if player.hand.size >= Game::Player::MAX_HAND_SIZE
            opponent.generate_choice_from_hand(prompt: :choose_one, only: :good?.to_proc) do |second_choice|
              player.hand << second_choice 
            end
          when :pay_me_5_gold
            cash = opponent.hoard.lose 5
            player.hoard.gain cash
          end
        end
      end
    end
  end
end


