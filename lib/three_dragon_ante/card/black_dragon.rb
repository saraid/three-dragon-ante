module ThreeDragonAnte
  class Card
    class BlackDragon < Card
      def initialize(strength)
        super('Black Dragon', %i( evil dragon ), strength)
      end
    end
  end
end
