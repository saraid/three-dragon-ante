RSpec.describe ThreeDragonAnte::Card::TheFool do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),

    # Then aleph will play the fool
    { type: ThreeDragonAnte::Card::TheFool },
  ] end

  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
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

      it 'should draw cards for each player with a stronger flight'
    end
  end
end
