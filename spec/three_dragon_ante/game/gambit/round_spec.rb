RSpec.describe ThreeDragonAnte::Game::Gambit::Round do
  let(:stacked_deck) { [
    # Guarantee that aleph starts 
    { strength: proc { _1 < 13 } },
    { strength: proc { _1 == 13 } },
    { strength: proc { _1 == 13 } }
  ] }
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :bet], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit}
  subject { gambit.current_round }

  describe '#run' do
    it do
      subject.current_player.current_choice.choose! 0

      subject.run
      subject.current_player.current_choice.choose! 0

      subject.run
      subject.current_player.current_choice.choose! 0

      expect(subject.ended?).to be true
    end
  end
end
