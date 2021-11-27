RSpec.describe ThreeDragonAnte::Card::TheFool do
  let(:stacked_deck) do [
    # We want aleph to go first, so we give them the highest card.
    { strength: proc { _1 == 13 } },
    # bet and gimel get lower strength cards
    { strength: proc { _1 < 13 } },
    { strength: proc { _1 < 13 } },

    # Then aleph will play the fool
    { type: ThreeDragonAnte::Card::TheFool },
  ] end

  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1], stacked_deck: stacked_deck) }
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
      before(:each) do
        
      end

    end
  end
end
