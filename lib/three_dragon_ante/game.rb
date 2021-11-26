require_relative './deck'
require_relative 'game/event'
require_relative 'game/gambit'
require_relative 'game/player'

module ThreeDragonAnte
  class Game
    def initialize
      @deck = Deck.new
      @players = []
      @events = []
      @history = []
    end
    attr_reader :deck, :players
    attr_reader :history

    def setup!
      @players.each do |player|
        player.hoard = 50
      end

      6.times do
        @players.each do |player|
          player.hand << @deck.draw!
        end
      end
    end

    def current_gambit
      @gambit = Gambit.new(self).tap(&@history.method(:<<)) if @gambit.nil? || @gambit.ended?
      @gambit
    end
  end
end
