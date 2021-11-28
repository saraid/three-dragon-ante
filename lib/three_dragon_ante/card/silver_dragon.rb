module ThreeDragonAnte
  class Card
    class SilverDragon < Card
      def initialize(strength)
        super('Silver Dragon', %i( good dragon ), strength)
      end

      def trigger_power!(gambit, player)
        gambit.current_round.players_leftward_from_current.each do |player_in_order|
          player_in_order.draw_card(gambit.game.deck) if gambit.flights[player_in_order].values.any?(&:good_dragon?)
        end
      end
    end
  end
end









