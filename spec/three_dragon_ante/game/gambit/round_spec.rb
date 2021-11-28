RSpec.describe ThreeDragonAnte::Game::Gambit::Round do
  let(:stacked_deck) { [
    *Factory.ante_to_choose_leader(:bet)
  ] }
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :bet], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit}
  subject { gambit.current_round }

  describe '#current_player_takes_turn' do
    it do
      subject.current_player.current_choice.choose! 0
      game.current_choices.values.each {  _1.choose!(0) } until game.current_choices.empty?

      subject.advance
      subject.current_player.current_choice.choose! 0
      game.current_choices.values.each {  _1.choose!(0) } until game.current_choices.empty?

      subject.advance
      subject.current_player.current_choice.choose! 0
      game.current_choices.values.each {  _1.choose!(0) } until game.current_choices.empty?

      expect(subject.ended?).to be true
    end
  end
end
