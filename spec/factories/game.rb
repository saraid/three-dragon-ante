module Factory
  PLAYER_IDENTIFIERS = %i( aleph bet gimel dalet he vav zayin chet tet yod kaf )
  def self.game(player_count: 3, setup_until: :waiting_for_players, stacked_deck: [])
    ThreeDragonAnte::Game.new.tap do |game|
      player_count.times do |i|
        game.players << ThreeDragonAnte::Game::Player.new(game).tap do |player|
          player.identifier = PLAYER_IDENTIFIERS[i]
        end
      end

      game.deck.stack_set! stacked_deck

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
        proc { game.current_gambit.current_round.run },
        proc { game.current_gambit.current_round.current_player.current_choice.choose!(0) },
        proc { game.current_choices.values.each {  _1.choose!(0) } until game.current_choices.empty? },
        proc { game.current_gambit.current_round.next_player if game.current_gambit.current_round.started? },
      ]

      round_actions.cycle.each do |action|
        break if game.current_phase == setup_until || game.current_gambit.ended? || game.current_gambit.rounds.size > 5
        action.call
      end

      gambit_end_actions = [
        proc { game.current_gambit.distribute_stakes },
      ]

      gambit_end_actions.each do |action|
        break if game.current_phase == setup_until
        action.call
      end
    end
  end
end
