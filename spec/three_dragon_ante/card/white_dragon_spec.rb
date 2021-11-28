RSpec.describe ThreeDragonAnte::Card::WhiteDragon do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    { type: ThreeDragonAnte::Card::TheFool },
    { type: ThreeDragonAnte::Card::WhiteDragon, strength: cmp(:<=, 3) },
  ] end
  let(:target_phase) { [:gambit, 1, :round, 1, :aleph] }

  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    context 'and a mortal has been played' do
      before(:each) do
        expect(game.players[0].current_choice.choices.first).to be_mortal
        game.players[0].current_choice.choose! 0
        gambit.current_round.advance
      end

      it 'should steal 3 gold from the stakes' do
        expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::WhiteDragon

        current_stakes = gambit.stakes.value
        game.players[1].current_choice.choose! 0
        expect(gambit.stakes.value).to eq(current_stakes - 3)
      end

      context 'when there is only 1 gold in the stakes' do
        before(:each) do
          gambit.stakes.lose(gambit.stakes.value - 1)
        end

        it 'should steal 1 gold and end the gambit' do
          expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::WhiteDragon

          game.players[1].current_choice.choose! 0
          expect(gambit.stakes.value).to eq 0
          expect(gambit.ended?).to eq true
        end
      end
    end

    context 'and a mortal has not been played' do
      let(:stacked_deck) do [
        *Factory.ante_to_choose_leader(:aleph),

        # Then aleph will have a thief
        { type: ThreeDragonAnte::Card::GoldDragon, strength: 6 },
        # Then bet will play a white dragon
        { type: ThreeDragonAnte::Card::WhiteDragon, strength: proc { _1 > 6 } }, # assure power triggers
      ] end

      before(:each) do
        expect(game.players[0].current_choice.choices.first).not_to be_mortal
        game.players[0].current_choice.choose! 0
        gambit.current_round.advance
      end

      it 'should do nothing' do
        expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::WhiteDragon

        current_stakes = gambit.stakes.value
        game.players[1].current_choice.choose! 0
        expect(gambit.stakes.value).to eq(current_stakes)
      end
    end
  end
end
