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

  describe '#ante_ready?' do
    it 'works' do
      game.setup!
      subject.accept_ante

      player_aleph.current_choice.choose!(0)
      expect(subject.ante_ready?).to eq false
      player_bet.current_choice.choose!(0)
      expect(subject.ante_ready?).to eq false
      player_gimel.current_choice.choose!(0)
      expect(subject.ante_ready?).to eq true
    end
  end

  describe '#reveal_ante' do
    it 'works' do
      game.setup!
      subject.accept_ante

      player_aleph.current_choice.choose!(0)
      player_bet.current_choice.choose!(0)
      player_gimel.current_choice.choose!(0)

      subject.reveal_ante
    end
  end

  describe '#choose_leader' do
    it 'works' do
      game.setup!
      subject.accept_ante

      player_aleph.current_choice.choose!(0)
      player_bet.current_choice.choose!(0)
      player_gimel.current_choice.choose!(0)

      subject.reveal_ante
      subject.choose_leader
    end

    it 'handles ties'
  end

  describe '#pay_stakes' do
    it 'works' do
      game.setup!
      subject.accept_ante

      player_aleph.current_choice.choose!(0)
      player_bet.current_choice.choose!(0)
      player_gimel.current_choice.choose!(0)

      subject.reveal_ante
      subject.choose_leader
      subject.pay_stakes
    end
  end
end
