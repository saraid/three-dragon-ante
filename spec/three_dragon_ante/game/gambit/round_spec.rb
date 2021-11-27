RSpec.describe ThreeDragonAnte::Game::Gambit::Round do
  let(:stacked_deck) { [] }
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit}
  subject { gambit.current_round }

  describe '#run' do
    xit do
      subject.run

      expect(game.players[0].current_choice).not_to be_nil
      game.players[0].current_choice.choose! 0
      expect(game.players[0].current_choice).to be_resolved
    end
  end
end
