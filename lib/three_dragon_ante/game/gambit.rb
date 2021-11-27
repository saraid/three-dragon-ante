require_relative 'gambit/player_ante'
require_relative 'gambit/round'

module ThreeDragonAnte
  class Game
    class Gambit
      def initialize(game)
        @game = game
        @current_phase = [:ante, :choice]
        @ante = []
        @rounds = []
        @flights = game.players.zip([]).to_h.transform_values.with_index do |_value, index|
          Evented::SetOfCards.new(game) { [game.players[index].identifier, :flight] }
        end

        @stakes = Evented::Integer.new(game) { [_1, :stakes, _2] }
      end
      attr_reader :game, :rounds
      attr_reader :ante, :leader, :flights, :stakes

      def ended?
        current_phase.first != :ante && (stakes.value.zero? || !@winner.nil?)
      end

      def players
        game.players
      end

      def run
        while @leader.nil?
          accept_ante
          reveal_ante
          choose_leader
        end
        pay_stakes
        play_rounds
        win_stakes
      end

      def accept_ante
        players.each do |player|
          player.generate_choice_from_hand(prompt: :for_ante) do |choice|
            @ante << PlayerAnte.new(player, player.hand >> choice)
          end
        end
      end

      def ante_ready?
        @ante.size == players.size
      end

      def reveal_ante
        @current_phase = [:ante, :reveal]
        game << @ante.map(&:card)
      end

      def choose_leader
        @current_phase = [:ante, :choose_leader]
        by_strength = @ante.group_by { _1.card.strength }
        @per_player_stakes = by_strength.keys.sort.reverse.first
        by_strength.keys.sort.reverse.each do |strength|
          players_at_strength = by_strength[strength].map(&:player)
          if players_at_strength.size == 1
            @leader = players_at_strength.first
            game << [:leader, @leader]

            break
          else
            game << [:tied, players_at_strength]
          end
        end
      end

      def pay_stakes
        @current_phase = [:ante, :pay_stakes]
        game.players.each do
          cash = _1.hoard.lose @per_player_stakes 
          stakes.gain cash
        end
      end

      def current_phase
        case @current_phase
        when Symbol, Array then @current_phase
        when Proc then @current_phase.call
        end
      end

      def current_round
        if @round.nil? || @round.ended?
          @round = Round.new(self).tap(&@rounds.method(:<<))
          @current_phase = proc { [:round, @rounds.size, @round.current_player.identifier] }
        end
        @round
      end

      def win_stakes
      end
    end
  end
end
