RSpec.describe ThreeDragonAnte::Card::BlueDragon do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),

    # Then aleph will play a blue dragon
    { type: ThreeDragonAnte::Card::BlueDragon },
  ] end

  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    it 'offers a choice' do
      game.players[0].current_choice.choose! 0
      expect(game.players[0].current_choice.prompt).to eq :choose_one
      expect(game.players[0].current_choice.choices).to eq %i(steal_per_evil_dragon others_pay_per_evil_dragon)
    end

    context 'and the player chooses to steal' do
      before(:each) do
        game.players[0].current_choice.choose! 0 # play BlueDragon
      end

      context 'and the player has no evil dragons except the blue' do
        it 'should steal 1 gold from stakes' do
          current_stakes = gambit.stakes.value
          current_hoard = game.players[0].hoard.value
          game.players[0].current_choice.choose! 0 # choose to steal
          expect(game.players[0].hoard.value).to eq(current_hoard + 1)
          expect(gambit.stakes.value).to eq(current_stakes - 1)
        end
      end
    end
  end
end
