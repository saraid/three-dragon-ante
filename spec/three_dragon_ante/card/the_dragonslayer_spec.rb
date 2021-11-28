RSpec.describe ThreeDragonAnte::Card::TheDragonslayer do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: {
      aleph: [{ type: ThreeDragonAnte::Card::BlackDragon, strength: proc { _1 < 8 } }],
      bet: [{ type: ThreeDragonAnte::Card::TheDragonslayer }],
      gimel: []
    })
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :bet], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'slays any weaker dragon' do
      gambit.current_round.run
      expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheDragonslayer

      game.players[1].current_choice.choose! 0 # play TheDragonslayer
      expect(game.players[1].current_choice).not_to be_nil
      expect(game.players[1].current_choice.choices.size).to eq 1

      game.players[1].current_choice.choose! 0 # slay BlackDragon
      expect(gambit.flights[game.players[0]].size).to eq 0
    end
  end
end
