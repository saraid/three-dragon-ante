module ThreeDragonAnte
  class Card
    class BronzeDragon < Card
      def initialize(strength)
        super('Bronze Dragon', %i( good dragon ), strength)
      end
    end
  end
end



