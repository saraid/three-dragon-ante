module ThreeDragonAnte
  class Card
    class Dracolich < Card
      def initialize
        super('Dracolich', %i(undead dragon), 10)
      end

      def trigger_power!(gambit, player)
        options = gambit.flights.values.map(&:values).flatten.select { _1.evil? }
        player.choose_one(*options, prompt: :copy_evil_power) do |choice|
          copy(choice.class, strength).trigger_power!(gambit, player)
        end
      end
    end
  end
end
