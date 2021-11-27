RSpec.describe ThreeDragonAnte::Game::Gambit::Round do
  let(:stacked_deck) { [
    *Factory.ante_to_choose_leader(:bet)
  ] }
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :bet], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit}
  subject { gambit.current_round }

  describe '#run' do
    it do
      subject.current_player.current_choice.choose! 0

      subject.advance
      subject.current_player.current_choice.choose! 0

      subject.advance
      subject.current_player.current_choice.choose! 0

      expect(subject.ended?).to be true
    end
  end
end
