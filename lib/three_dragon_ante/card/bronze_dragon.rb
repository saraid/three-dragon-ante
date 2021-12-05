module ThreeDragonAnte
  class Card
    class BronzeDragon < Card
      def initialize(strength)
        super('Bronze Dragon', %i( good dragon ), strength)
      end

      manipulates_ante!
      manipulates_hands!

      def trigger_power!(gambit, player)
        cards_to_take = [Game::Player::MAX_HAND_SIZE - player.hand.size, 2].min
        return if cards_to_take.zero?

        cards_to_take.times.each do |i|
          remaining_cards_to_take = cards_to_take - i
          puts "Remaining to take: #{remaining_cards_to_take}"
          break if gambit.ante.empty?

          by_strength = gambit.ante.group_by(&:strength)
          strength = by_strength.keys.sort.first
          puts "Take strength #{strength}"
          if by_strength[strength].size > remaining_cards_to_take
            player.choose_one(by_strength[strength]) do |choice|
              player.hand << (gambit.ante >> choice)
            end
          elsif by_strength[strength].size <= remaining_cards_to_take
            player.hand << (gambit.ante >> by_strength[strength].first)
          end
        end
      end
    end
  end
end
