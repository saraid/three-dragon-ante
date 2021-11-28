module ThreeDragonAnte
  class Card
    class Tiamat < Card
      def initialize
        super('Tiamat', %i( evil dragon god ), 13)
      end

      def trigger_power!(gambit, player)
        # Tiamut has no power
      end
    end
  end
end
