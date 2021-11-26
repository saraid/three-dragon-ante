module ThreeDragonAnte
  class Card
    class BrassDragon < Card
      def initialize(strength)
        super('Brass Dragon', %i( good dragon ), strength)
      end
    end
  end
end


