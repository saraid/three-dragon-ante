RSpec.describe ThreeDragonAnte::Card::TheThief do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),

    # Then aleph will play the thief
    { type: ThreeDragonAnte::Card::TheThief },
  ] end
  let(:target_phase) { [:gambit, 1, :round, 1, :aleph] }

  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  before(:each) { gambit.current_round.run }

  context 'when triggered' do
    it 'should lose 7 gold' do
      expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheThief

      current_stakes = gambit.stakes.value
      current_hoard_size = game.players[0].hoard.value
      game.players[0].current_choice.choose! 0
      expect(gambit.stakes.value).to eq(current_stakes - 7)
      expect(game.players[0].hoard.value).to eq(current_hoard_size + 7)

      expect(game.players[0].current_choice).not_to be_nil # still have a choice to resolve
      current_hand_size = game.players[0].hand.size
      game.players[0].current_choice.choose! 0
      expect(game.players[0].hand.size).to eq(current_hand_size - 1)
    end
  end
end
