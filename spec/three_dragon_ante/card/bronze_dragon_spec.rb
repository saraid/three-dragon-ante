RSpec.describe ThreeDragonAnte::Card::BronzeDragon do
  let(:game) do
    Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: [
      *ante,

      # Then aleph will play a bronze dragon
      { type: ThreeDragonAnte::Card::BronzeDragon },
    ])
  end
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    context 'and the ante is all different strengths' do
      let(:ante) do [
        { strength: 13 }, { strength: 12 }, { strength: 11 }
      ] end

      it 'should take the two weakest ; no choice' do
        game.players[0].current_choice.choose! 0 # play BronzeDragon
        expect(gambit.ante.size).to eq 1
        expect(game.players[0].hand.size).to eq 6
      end
    end

    context 'and the ante has two weakest of same strength' do
      let(:ante) do [
        { strength: 13 }, { strength: 11 }, { strength: 11 }
      ] end

      it 'should take the two weakest ; no choice' do
        current_hand_size = game.players[0].hand.size
        game.players[0].current_choice.choose! 0 # play BronzeDragon
        expect(game.players[0].hand.size).to eq 6
        expect(gambit.ante.size).to eq 1
      end
    end
  end
end
