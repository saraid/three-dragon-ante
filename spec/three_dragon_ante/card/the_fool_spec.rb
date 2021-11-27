RSpec.describe ThreeDragonAnte::Card::TheFool do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),

    # Then aleph will play the fool
    { type: ThreeDragonAnte::Card::TheFool },
  ] end
  let(:target_phase) { [:gambit, 1, :round, 1, :aleph] }

  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  before(:each) { gambit.current_round.run }

  context 'when triggered' do
    context 'as the first card played' do
      it 'should lose 1 gold' do
        expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheFool

        current_hoard_size = game.players[0].hoard.value
        game.players[0].current_choice.choose! 0
        expect(game.players[0].hoard.value).to eq(current_hoard_size - 1)
      end
    end

    context 'when other players have stronger flights' do
      let(:target_phase) { [:gambit, 1, :round, 2, :aleph] }
      let(:stacked_deck) do [
        *Factory.ante_to_choose_leader(:aleph),

        # Then aleph will play the fool
        { strength: proc { _1 < 5 } }, # max strength: 4 + Fool (3) = 7
        { strength: proc { _1 > 7 } },
        { strength: proc { _1 > 7 } },

        # Then aleph will play the fool
        { type: ThreeDragonAnte::Card::TheFool },
      ] end

      it 'should draw cards for each player with a stronger flight' do
        expect(game.players[0].current_choice.choices.first).to be_a ThreeDragonAnte::Card::TheFool

        current_hand_size = game.players[0].hand.size
        game.players[0].current_choice.choose! 0
        expect(game.players[0].hand.size).to eq(current_hand_size + 1) # card played (-1) draw 2 (+2)
      end
    end
  end
end
