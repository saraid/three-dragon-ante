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
        *10.times.map do
          game.players.size.times.map do [
            proc { game.current_gambit.current_round.run },
            proc { game.current_gambit.current_round.current_player.current_choice.choose!(0) },
          ] end
        end.flatten
      ]

      setup_actions.each do |action|
        break if game.current_phase == setup_until 
        action.call
      end
    end
  end
end
