module ThreeDragonAnte
  class Card
    class BlueDragon < Card
      def initialize(strength)
        super('Blue Dragon', %i( evil dragon ), strength)
      end
    end
  end
end

