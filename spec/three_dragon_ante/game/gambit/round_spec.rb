RSpec.describe ThreeDragonAnte::Game::Gambit::Round do
  let(:game) { Factory.game }
  let(:gambit) { game.current_gambit}
  subject { gambit.current_round }

  before(:each) do
    game.setup!
    gambit.accept_ante
    gambit.players.each { _1.current_choice.choose!(0) }
    gambit.reveal_ante
    gambit.choose_leader
    gambit.pay_stakes
  end

  describe '#run' do
    it do
      subject.run

      game.players.each do |player|
        expect(player.current_choice).not_to be_nil
      end
    end
  end
end
