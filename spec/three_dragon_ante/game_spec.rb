RSpec.describe ThreeDragonAnte::Game do
  subject { Factory.game }

  describe '#setup!' do
    before(:each) { subject.setup! }

    it 'should deal 6 cards to each player' do
      subject.players.each do |player|
        expect(player.hand.size).to eq(6)
      end
    end

    it 'should give 50 gold to each player hoard' do
      subject.players.each do |player|
        expect(player.hoard.value).to eq(50)
      end
    end

    it 'should create 6 card-events and 1 hoard event per player' do
      expected_count = (6 + 1) * subject.players.size + subject.players.size
      expect(subject.events.size).to eq(expected_count)
    end
  end
end
