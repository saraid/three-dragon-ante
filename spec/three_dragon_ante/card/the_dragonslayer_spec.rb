RSpec.describe ThreeDragonAnte::Card::TheDragonslayer do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph, but_not: ThreeDragonAnte::Card::TheDragonslayer),
    *Factory.flights(flights: {
      aleph: [
        { type: ThreeDragonAnte::Card::BlackDragon, strength: cmp(:>=, 8) },
        { type: ThreeDragonAnte::Card::TheDragonslayer },
      ],
      bet: [{ is_not: [ThreeDragonAnte::Card::TheDragonslayer], strength: cmp(:<, 8), tags: %i(dragon) }],
      gimel: [
        { is_not: [ThreeDragonAnte::Card::TheDragonslayer], strength: cmp(:>=, 8) },
        { is_not: [ThreeDragonAnte::Card::TheDragonslayer], strength: cmp(:>=, 8) }
      ],
    })
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 2, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'slays any weaker dragon' do
      gambit.current_round.current_player_takes_turn
      expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheDragonslayer

      game.players[0].current_choice.choose! 0 # play TheDragonslayer
      expect(game.players[0].current_choice).not_to be_nil
      expect(game.players[0].current_choice.prompt).to eq :slay
      expect(game.players[0].current_choice.choices.size).to be >= 1

      current_flight_size = gambit.flights[game.players[1]].size
      game.players[0].current_choice.choose! 0 # slay bet's dragon
      expect(gambit.flights[game.players[1]].size).to eq(current_flight_size - 1)
    end
  end
end
