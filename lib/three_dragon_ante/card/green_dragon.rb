module ThreeDragonAnte
  class Card
    class GreenDragon < Card
      def initialize(strength)
        super('Green Dragon', %i( evil dragon ), strength)
      end

      manipulates_hands!
      manipulates_hoards!

      def trigger_power!(gambit, player)
        opponent = gambit.current_round.player_left_of_current

        if strength == 1
          cash = opponent.hoard.lose(5, to: player)
          player.hoard.gain cash
          return
        end

        opponent.choose_one(:pay_me_5_gold, :give_weaker_evil_dragon) do |choice|
          case choice
          when :give_weaker_evil_dragon
            next if player.hand.size >= Game::Player::MAX_HAND_SIZE
            opponent.generate_choice_from_hand(
              prompt: :choose_to_give, only: proc { _1.evil_dragon? && _1.strength < strength}
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
