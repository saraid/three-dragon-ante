RSpec.describe ThreeDragonAnte::Game::Player::Hoard do
  let(:game) { ThreeDragonAnte::Game.new }
  let(:player) { ThreeDragonAnte::Game::Player.new(game) }
  let(:opponent) { ThreeDragonAnte::Game::Player.new(game) }

  before(:each) { player.hoard.gain(5) }

  context 'when a player must pay stakes' do
    it 'should not create a debt' do
      player.hoard.lose(10)

      expect(player.hoard.value).to eq(0)
      expect(player.hoard.debts).to be_empty
    end
  end

  context 'when a player cannot pay another' do
    it 'should create a debt' do
      opponent.hoard.gain(player.hoard.lose(10, to: opponent))

      expect(opponent.hoard.value).to eq(5)
      expect(player.hoard.value).to eq(0)
      expect(player.hoard.debts).not_to be_empty
    end
  end

  context 'when gaining hoard while indebted' do
    before(:each) { opponent.hoard.gain(player.hoard.lose(10, to: opponent)) }

    it 'should first pays owed opponent' do
      expect(opponent.hoard.value).to eq 5
      expect(player.hoard.value).to eq 0

      player.hoard.gain 10

      expect(opponent.hoard.value).to eq 10
      expect(player.hoard.value).to eq 5
    end
  end
end
