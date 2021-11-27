RSpec.describe ThreeDragonAnte::Card::BlackDragon do
  let(:game) do
    Factory.game(setup_until: [:gambit, 1, :round, 1], stacked_deck: [
      # We want aleph to go first, so we give them the highest card.
      { strength: proc { _1 == 13 } },
      # bet and gimel get lower strength cards
      { strength: proc { _1 < 13 } },
      { strength: proc { _1 < 13 } },

      # Then aleph will play a black dragon
      { type: ThreeDragonAnte::Card::BlackDragon },
    ])
  end
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'should steal 2 gold from the stakes' do
      gambit.current_round.run
      expect(game.players.first.current_choice.choices.first).to be_a ThreeDragonAnte::Card::BlackDragon

      current_stakes = gambit.stakes.value
      game.players.first.current_choice.choose! 0
      expect(gambit.stakes.value).to eq(current_stakes - 2)
    end

    context 'when there is only 1 gold in the stakes' do
      it 'should steal 1 gold and end the gambit' do
        gambit.current_round.run
        expect(game.players.first.current_choice.choices.first).to be_a ThreeDragonAnte::Card::BlackDragon

        gambit.stakes.lose(gambit.stakes.value - 1)
        game.players.first.current_choice.choose! 0
        expect(gambit.stakes.value).to eq 0

        expect(gambit.over?).to eq true
      end
    end
  end
end
