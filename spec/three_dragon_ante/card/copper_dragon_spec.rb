RSpec.describe ThreeDragonAnte::Card::CopperDragon do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: { aleph: [{ type: ThreeDragonAnte::Card::CopperDragon }], bet: [], gimel: [] }),
    { type: ThreeDragonAnte::Card::BlackDragon }
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'executes the power of the first card of the deck' do
      top_of_deck = game.deck.peek(1).first
      expect(top_of_deck).to be_a ThreeDragonAnte::Card::BlackDragon

      expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::CopperDragon
      current_stakes = gambit.stakes.value
      player_hoard = game.players[0].hoard.value
      game.players[0].current_choice.choose! 0 # play CopperDragon

      # Black Dragon power executed
      expect(gambit.flights[game.players[0]].values.last).to eq(top_of_deck)
      expect(gambit.stakes.value).to eq(current_stakes - 2)
      expect(game.players[0].hoard.value).to eq(player_hoard + 2)
    end
  end
end
