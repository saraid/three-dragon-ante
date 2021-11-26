RSpec.describe ThreeDragonAnte::Game::Gambit do
  let(:game) { Factory.game }
  let(:player_aleph) { game.players[0] }
  let(:player_bet) { game.players[1] }
  let(:player_gimel) { game.players[2] }

  subject { game.current_gambit }

  describe '#accept_ante' do
    it 'does not raise' do
      game.setup!
      subject.accept_ante

      expect(player_aleph.current_choice).not_to be_nil
      expect(player_bet.current_choice).not_to be_nil
      expect(player_gimel.current_choice).not_to be_nil
    end
  end
end
