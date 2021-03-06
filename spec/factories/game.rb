module Factory
  def self.game(player_count: 3, setup_until: :waiting_for_players, stacked_deck: [])
    ThreeDragonAnte::Game.new.tap do |game|
      player_count.times { |i| game.players << Factory.player(game, PLAYER_IDENTIFIERS[i]) }

      game.deck.stack_set! stacked_deck
      #puts game.deck.peek(stacked_deck.size)

      setup_actions = [
        proc { game.setup! },
        proc { game.current_gambit.accept_ante },
        proc { game.players.each { _1.current_choice.choose!(0) } },
        proc { game.current_gambit.reveal_ante },
        proc { game.current_gambit.choose_leader },
        proc { game.current_gambit.pay_stakes },
      ]

      setup_actions.each do |action|
        break if game.current_phase == setup_until 
        action.call
      end

      round_actions = [
        proc { game.current_gambit.current_round.current_player_takes_turn },
        proc { game.current_gambit.current_round.current_player.current_choice.choose!(0) },
        proc do
          game.current_choices.values.each do
            _1.choose!(_1.choices.empty? ? nil : 0) 
          end until game.current_choices.empty?
        end,
        proc { game.current_gambit.current_round.next_player if game.current_gambit.current_round.started? },
      ]

      round_actions.cycle.each do |action|
        break if game.current_phase == setup_until || game.current_gambit.ended? || game.current_gambit.rounds.size > 5
        action.call
      end

      gambit_end_actions = [
        proc { game.current_gambit.distribute_stakes },
        proc { game.current_gambit.cleanup },
      ]

      gambit_end_actions.each do |action|
        break if game.current_phase == setup_until
        action.call
      end
    end
  end
end
