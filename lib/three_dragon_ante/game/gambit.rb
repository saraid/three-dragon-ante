require_relative 'gambit/flight'
require_relative 'gambit/player_choice'
require_relative 'gambit/round'

module ThreeDragonAnte
  class Game
    class Gambit
      def initialize(game)
        @game = game
        @current_phase = [:ante, :choice]
        @ante = []
        @ante_cards = Evented::SetOfCards.new(game, &Event::AnteChanged.method(:[]))
        @rounds = []
        @flights = players.zip(players).to_h.transform_values do |player|
          Flight.new(game, &Event::PlayerFlightChanged[player])
        end

        @stakes = Evented::Integer.new(game, &Event::GambitStakesChanged.method(:[]))
      end
      attr_reader :game, :rounds
      attr_reader :leader, :flights, :stakes

      def ended?
        current_phase.first != :ante && (stakes.value.zero? || !winner.nil?)
      end

      def stakes_distributed?
        current_phase == :stakes_distributed
      end

      def ante
        @ante_cards
      end

      def players
        @players ||= game.players.dup
      end

      def run
        while @leader.nil?
          accept_ante
          reveal_ante
          choose_leader
        end
        pay_stakes
        play_rounds
        distribute_stakes
      end

      def accept_ante
        players.each do |player|
          player.generate_choice_from_hand(prompt: :for_ante) do |choice|
            @ante << PlayerChoice.new(player, player.hand >> choice)
            @ante_cards << choice
          end
        end
      end

      def ante_ready_to_reveal?
        @ante.size == players.size
      end

      def leader_determined?
        !!@leader
      end

      def reveal_ante
        @current_phase = [:ante, :reveal]
        game << Event::AnteRevealed[@ante]
      end

      def temporary_leader=(player)
        @temporary_leader = player
      end

      def choose_leader(phase = [:ante, :choose_leader], chosen_cards = @ante)
        @current_phase = phase
        by_strength = chosen_cards.group_by { _1.card.strength }
        @per_player_stakes = by_strength.keys.sort.reverse.first
        by_strength.keys.sort.reverse.each do |strength|
          players_at_strength = by_strength[strength].map(&:player)
          if players_at_strength.size == 1
            @leader = players_at_strength.first
            game << Event::LeaderChosen[@leader]

            break
          else
            game << Event::AnteTied.new
          end
        end
      end

      def pay_stakes
        @current_phase = [:ante, :pay_stakes]
        players.each do
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
          choose_leader([:round, @rounds.size, :choose_leader], @rounds.last.cards_played) unless @rounds.empty?
          @round = Round.new(self, @temporary_leader || @leader).tap(&@rounds.method(:<<))
          @current_phase = proc { [:round, @rounds.size, @round.current_player.identifier] }
        end
        @round
      end

      def winner
        return if @rounds.select(&:ended?).size < 3

        druid_in_flight = @flights.values.map(&:values).any? { Card::TheDruid === _1 }
        by_strength = @flights.select { _2.can_win? }.group_by { _2.strength }
        winning_flight_strength = by_strength.keys.sort.send(druid_in_flight ? :first : :last)
        return if by_strength[winning_flight_strength].size > 1

        player, flight = by_strength[winning_flight_strength].first
        @winner = player
      end

      def distribute_stakes
        @current_phase = :distribute_stakes
        puts @flights.map { |player, flight| "#{player.identifier} (#{flight.strength}): #{flight.inspect}" }
        @winner.hoard.gain @stakes.value
      end

      def cleanup
        @current_phase = :cleanup
        ante.each { game.deck.discarded _1 }
        flights.each { _2.each { |card| game.deck.discarded card } }

        players.each do |player|
          players >> player if player.hoard.value <= 0
          2.times { player.draw_card! }
        end

      end
    end
  end
end
