RSpec.describe ThreeDragonAnte::Card::TheArchmage do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    { type: ThreeDragonAnte::Card::TheArchmage }
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'offers a choice of ante cards' do
      expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheArchmage
      game.players[0].current_choice.choose! 0 # play TheArchmage

      expect(game.players[0].current_choice).not_to be_nil
      expect(game.players[0].current_choice.choices.size).to eq 3
    end
  end
end
