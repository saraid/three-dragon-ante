RSpec.describe ThreeDragonAnte::Game::Gambit do
  let(:player_aleph) { game.players[0] }
  let(:player_bet) { game.players[1] }
  let(:player_gimel) { game.players[2] }

  subject { game.current_gambit }

  describe '#accept_ante' do
    let(:game) { Factory.game(setup_until: [:gambit, 1, :ante, :choice]) }

    it 'does not raise' do
      subject.accept_ante

      expect(player_aleph.current_choice).not_to be_nil
      expect(player_bet.current_choice).not_to be_nil
      expect(player_gimel.current_choice).not_to be_nil
    end
  end

  describe '#ante_ready_to_reveal?' do
    let(:game) { Factory.game(setup_until: [:gambit, 1, :ante, :choice]) }
    it 'works' do
      subject.accept_ante

      player_aleph.current_choice.choose!(0)
      expect(subject.ante_ready_to_reveal?).to eq false
      player_bet.current_choice.choose!(0)
      expect(subject.ante_ready_to_reveal?).to eq false
      player_gimel.current_choice.choose!(0)
      expect(subject.ante_ready_to_reveal?).to eq true
    end
  end

  describe '#reveal_ante' do
    let(:game) { Factory.game(setup_until: [:gambit, 1, :ante, :reveal]) }
    it 'works' do
      subject.reveal_ante

      expect(game.events.last.details.ante.size).to eq(game.players.size)
    end
  end

  describe '#choose_leader' do
    context 'when there is no tie' do
      let(:game) do
        Factory.game(setup_until: [:gambit, 1, :ante, :choose_leader], stacked_deck: [
          { strength: 10 },
          { strength: 13 },
          { strength: 8 },
        ])
      end

      it 'choose bet' do
        subject.choose_leader

        expect(subject.leader.identifier).to eq :bet
      end
    end

    context 'when there is a tie' do
      let(:game) do
        Factory.game(setup_until: [:gambit, 1, :ante, :choose_leader], stacked_deck: [
          { strength: 10 },
          { strength: 8 },
          { strength: 10 },
        ])
      end

      it 'choose bet' do
        subject.choose_leader

        expect(subject.leader.identifier).to eq :bet
      end
    end

    context 'when everyone ties' do
      let(:game) do
        Factory.game(setup_until: [:gambit, 1, :ante, :choose_leader], stacked_deck: [
          { strength: 10 },
          { strength: 10 },
          { strength: 10 },
        ])
      end

      it 'no choice' do
        subject.choose_leader

        expect(subject.leader).to be_nil
      end
    end
  end

  describe '#pay_stakes' do
    let(:game) do
      Factory.game(setup_until: [:gambit, 1, :ante, :pay_stakes])
    end

    it 'works' do
      subject.pay_stakes

      expect(subject.stakes.value).to be > 0
    end
  end

  describe '#winner' do
    let(:stacked_deck) do [
      *Factory.ante_to_choose_leader(:aleph),
      *Factory.flights(player_order: %i( aleph bet gimel ), flights: {
        aleph: [ { strength:  8 }, { strength: 5 }, { strength: 3 } ].each { _1[:no_manip] = %i(hands) }, # strength=16
        bet:   [ { strength:  9 }, { strength: 9 }, { strength: 1 } ].each { _1[:no_manip] = %i(hands) }, # strength=19
        gimel: [ { strength: 11 }, { strength: 3 }, { strength: 2 } ].each { _1[:no_manip] = %i(hands) }, # strength=16
      })
    ] end
    let(:game) { Factory.game(setup_until: [:gambit, 1, :win_stakes], stacked_deck: stacked_deck) }

    it 'should be bet' do
      expect(subject.winner).to be game.players[1]
    end
  end
end
