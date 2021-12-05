require 'logger'

require_relative './deck'
require_relative 'game/event'
require_relative 'game/gambit'
require_relative 'game/listenable_array'
require_relative 'game/player'

module ThreeDragonAnte
  class Game
    include Refinements::Inspection

    def initialize
      @current_phase = :waiting_for_players
      @deck = Deck.new
      @players = Evented::Array.new(self, &Event::GamePlayersChanged.method(:[]))
      @events = ListenableArray.new
      @event_logger = Logger.new($stdout)
      @gambits = []
    end
    attr_reader :deck, :players
    attr_reader :events, :event_logger

    def setup!
      @current_phase = :setup

      @players.each do |player|
        player.hoard.gain Player::STARTING_HOARD_SIZE
      end

      Player::STARTING_HAND_SIZE.times do
        @players.each do |player|
          player.hand << @deck.draw!
        end
      end
    end

    def current_phase
      case @current_phase
      when Symbol, Array then @current_phase
      when Proc then @current_phase.call
      end
    end

    def <<(event_details)
      @events << Event.new(self, current_phase, event_details).tap do |event|
        @event_logger.info event.to_s
      end
    end

    def current_gambit
      if @gambit.nil? || @gambit.stakes_distributed?
        @gambit = Gambit.new(self).tap(&@gambits.method(:<<))
        @current_phase = proc { [:gambit, @gambits.size, *@gambit.current_phase] }
      end
      @gambit
    end

    def current_choices
      players.zip(players.map(&:current_choice)).to_h.compact
    end
  end
end
