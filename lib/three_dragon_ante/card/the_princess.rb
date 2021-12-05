module ThreeDragonAnte
  class Card
    class ThePrincess < Card
      def initialize
        super('The Princess', %i( mortal ), 4)
      end

      manipulates_everything!

      def trigger_power!(gambit, player)
        cash = player.hoard.lose 1
        gambit.stakes.gain cash

        choose_option = lambda do |remaining_options|
          player.choose_one(*remaining_options) do |choice|
            choice.each { _1.trigger_power!(gambit, player) }
            remaining_options.delete(choice)
            choose_option.call(remaining_options) if remaining_options.any?
          end
        end

        options = gambit.flights[player].values.select(&:good_dragon?)
        choose_option.call(options) if options.any?
      end
    end
  end
end
