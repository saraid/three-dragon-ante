RSpec.describe ThreeDragonAnte::Card::ThePrincess do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: {
      aleph: aleph_flight,
      bet: [],
      gimel: gimel_flight,
    })
  ] end
  let(:target_phase) { [:gambit, 1, :round, 3, :aleph] }
  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }
  let(:player_aleph) { game.players[0] }
  let(:aleph_flight) { [{ type: ThreeDragonAnte::Card::ThePrincess }] }
  let(:gimel_flight) { [] }

  context 'when triggered' do
    let(:target_phase) { [:gambit, 1, :round, 1, :aleph ] }

    it 'should pay 1 into stakes' do
      current_stakes = gambit.stakes.value
      player_aleph.current_choice.choose! 0 # play card
      expect(gambit.stakes.value).to eq(current_stakes + 1)
    end

    context 'and there are no good dragons' do
      let(:target_phase) { [:gambit, 1, :round, 1, :aleph ] }
      let(:aleph_flight) do
        [ { type: ThreeDragonAnte::Card::ThePrincess } ]
      end

      it 'should do nothing' do
        player_aleph.current_choice.choose! 0 # play card
        expect(player_aleph.current_choice.choices.sort).to eq(%i(buy_cards nothing))
      end
    end

    context 'and there is 1 good dragons' do
      let(:target_phase) { [:gambit, 1, :round, 2, :aleph ] }
      let(:aleph_flight) do
        [ { type: ThreeDragonAnte::Card::BronzeDragon },
          { type: ThreeDragonAnte::Card::ThePrincess } ]
      end
      let(:gimel_flight) do
        [ { is_not: [ThreeDragonAnte::Card::ThePrincess] }, { strength: cmp(:>, 3) }]
      end

      it 'should trigger the good dragon' do
        gambit.current_round.current_player_takes_turn
        player_aleph.current_choice.choose! 0 # play card
        expect(player_aleph.current_choice.choices.size).to eq 1
        expect(player_aleph.current_choice.choices.first).to be_a ThreeDragonAnte::Card
        expect(player_aleph.current_choice.choices.first).to be_a ThreeDragonAnte::Card::BronzeDragon
      end
    end

    context 'and there are 2 good dragons' do
      let(:target_phase) { [:gambit, 1, :round, 3, :aleph ] }
      let(:aleph_flight) do
        [ { type: ThreeDragonAnte::Card::BronzeDragon },
          { type: ThreeDragonAnte::Card::GoldDragon },
          { type: ThreeDragonAnte::Card::ThePrincess } ]
      end
    end
  end
end
