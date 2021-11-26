require 'logger'

require_relative './deck'
require_relative 'game/event'
require_relative 'game/gambit'
require_relative 'game/player'

module ThreeDragonAnte
  class Game
    include Refinements::Inspection

    def initialize
      @deck = Deck.new
      @players = Evented::Array.new(self) { [_1, :player] }
      @events = []
      @event_logger = Logger.new($stdout)
      @history = []
    end
    attr_reader :deck, :players
    attr_reader :events

    def setup!
      @current_phase = :setup

      @players.each do |player|
        player.hoard.gain 50
      end

      6.times do
        @players.each do |player|
          player.hand << @deck.draw!
        end
      end
    end

    def <<(event_details)
      @events << Event.new(self, @current_phase, event_details).tap do |event|
        @event_logger.info event.to_s
      end
    end

    def current_gambit
      @gambit = Gambit.new(self).tap(&@history.method(:<<)) if @gambit.nil? || @gambit.ended?
      @gambit
    end
  end
end
