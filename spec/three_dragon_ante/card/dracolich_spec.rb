RSpec.describe ThreeDragonAnte::Card::Dracolich do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: {
      aleph: [{ type: ThreeDragonAnte::Card::RedDragon, strength: cmp(:>=, 10) }],
      bet: [{ type: ThreeDragonAnte::Card::Dracolich }],
      gimel: []
    })
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :bet], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'copies the power of an evil dragon in any flight' do
      gambit.current_round.current_player_takes_turn
      expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::Dracolich

      game.players[1].current_choice.choose! 0 # play Dragolich
      expect(game.players[1].current_choice).not_to be_nil
      expect(game.players[1].current_choice.choices.size).to eq 1

      opponent_hoard = game.players[0].hoard.value
      opponent_hand = game.players[0].hand.size
      player_hand = game.players[1].hand.size
      game.players[1].current_choice.choose! 0 # copy RedDragon
      expect(game.players[0].hoard.value).to eq(opponent_hoard - 1)
      expect(game.players[0].hand.size).to eq(opponent_hand - 1)
      expect(game.players[1].hand.size).to eq(player_hand + 1)
    end
  end
end
