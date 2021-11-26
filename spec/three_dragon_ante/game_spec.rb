RSpec.describe ThreeDragonAnte::Game do
  subject { Factory.game }

  describe '#setup!' do
    it 'should deal 6 cards to each player' do
      subject.setup!

      subject.players.each do |player|
        expect(player.hand.size).to eq(6)
      end
    end
  end
end
