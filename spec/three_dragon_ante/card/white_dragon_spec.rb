RSpec.describe ThreeDragonAnte::Card::WhiteDragon do
  let(:stacked_deck) do [
    # We want aleph to go first, so we give them the highest card.
    { strength: proc { _1 == 13 } },
    # bet and gimel get lower strength cards
    { strength: proc { _1 < 13 } },
    { strength: proc { _1 < 13 } },

    # Then aleph will have a thief
    { type: ThreeDragonAnte::Card::TheFool },
    # Then bet will play a white dragon
    { type: ThreeDragonAnte::Card::WhiteDragon },
  ] end

  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    context 'and a mortal has been played' do
      before(:each) do
        expect(game.players[0].current_choice.choices.first).to be_mortal
        game.players[0].current_choice.choose! 0
      end

      it 'should steal 3 gold from the stakes' do
        gambit.current_round.run
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
          gambit.current_round.run
          expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::WhiteDragon

          game.players[1].current_choice.choose! 0
          expect(gambit.stakes.value).to eq 0
          expect(gambit.over?).to eq true
        end
      end
    end

    context 'and a mortal has not been played' do
      let(:stacked_deck) do [
        # We want aleph to go first, so we give them the highest card.
        { strength: proc { _1 == 13 } },
        # bet and gimel get lower strength cards
        { strength: proc { _1 < 13 } },
        { strength: proc { _1 < 13 } },

        # Then aleph will have a thief
        { type: ThreeDragonAnte::Card::GoldDragon },
        # Then bet will play a white dragon
        { type: ThreeDragonAnte::Card::WhiteDragon },
      ] end

      before(:each) do
        expect(game.players[0].current_choice.choices.first).not_to be_mortal
        game.players[0].current_choice.choose! 0
      end

      it 'should do nothing' do
        gambit.current_round.run
        expect(game.players[1].current_choice.choices.first).to be_a ThreeDragonAnte::Card::WhiteDragon

        current_stakes = gambit.stakes.value
        game.players[1].current_choice.choose! 0
        expect(gambit.stakes.value).to eq(current_stakes)
      end
    end
  end
end
