module ThreeDragonAnte
  class Game
    class Event
      def initialize(message)
        @message = message
      end
      attr_reader :message
    end
  end
end
