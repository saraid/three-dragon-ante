require_relative 'event/phase'
require_relative 'event/details'

Dir.each_child(File.join(__dir__, 'evented')) do |evented|
  next unless evented.end_with?('.rb')
  require_relative "evented/#{evented}"
end

module ThreeDragonAnte
  class Game
    class Event
      def initialize(game, phase, details)
        @game = game
        @phase, @details = Phase.from_array(phase), details
      end
      attr_reader :game
      attr_reader :phase, :details

      def to_s
        details.inspect.tap do |string|
          string.prepend("[#{phase}] ") if phase
        end
      end
    end
  end
end
