RSpec.describe ThreeDragonAnte::Game::Gambit do
  let(:game) { Factory.game }

  subject { game.current_gambit }

  describe '#accept_ante' do
    it 'does not raise' do
      subject.accept_ante
    end
  end
end
