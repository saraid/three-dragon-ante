RSpec.describe ThreeDragonAnte::Card::BrassDragon do
  let(:target_phase) { [:gambit, 1, :round, 1, :gimel] }
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: {
      aleph: [{ strength: proc { _1 > 10 } }], # guarantee strongest flight
      bet: [{ strength: proc { _1 < 5 } }], # guarantee weakest flight and next player will trigger
      gimel: [{ type: ThreeDragonAnte::Card::BrassDragon, strength: proc { (5..10).include? _1 } }]
    })
  ] end

  let(:game) { Factory.game(setup_until: target_phase, stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    let(:opponent) { game.players[0] }
    let(:player) { game.players[2] }

    before(:each) do
      gambit.current_round.run
      player.current_choice.choose! 0 # play BrassDragon
    end

    it 'offers a choice to opponent with strongest flight' do
      expect(opponent.current_choice.prompt).to eq :choose_one
      expect(opponent.current_choice.choices.size).to eq 2
    end

    context 'and the opponent chooses to give a stronger good dragon' do
      before(:each) do
        opponent.current_choice.choose! 0 # choose to give
      end

      it 'should offer a choice of stronger good dragons' do
        expect(opponent.current_choice.prompt).to eq :choose_to_give
      end

      context 'and has a stronger good dragon' do
        let(:stacked_deck) do [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            # guarantee aleph has strongest flight, hand has good dragon
            aleph: [{ strength: proc { _1 > 10 } }, { tags: %i( good dragon), strength: proc { _1 > 10 } }],
            bet: [{ strength: proc { _1 < 5 } }], # guarantee weakest flight and next player will trigger
            gimel: [{ type: ThreeDragonAnte::Card::BrassDragon, strength: proc { (5..10).include? _1 } }]
          })
        ] end

        it 'should successfully give a stronger good dragon' do
          current_player_hand = player.hand.size
          current_opponent_hand = opponent.hand.size
          opponent.current_choice.choose!(0)
          expect(player.hand.size).to eq(current_player_hand + 1)
          expect(opponent.hand.size).to eq(current_opponent_hand - 1)
        end
      end

      context 'and does not have a stronger good dragon' do
        let(:stacked_deck) do [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            # guarantee aleph has strongest flight, hand has weaker good dragon
            aleph: [{ strength: proc { _1 > 10 } },
                    { tags: %i( good dragon), strength: proc { _1 < 5 } },
                    *4.times.map { { is_not: %i( good ) } }],
            bet: [{ strength: proc { _1 < 5 } }], # guarantee weakest flight and next player will trigger
            gimel: [{ type: ThreeDragonAnte::Card::BrassDragon, strength: proc { (5..10).include? _1 } }]
          })
        ] end

        it 'should give nothing' do
          current_player_hand = player.hand.size
          current_opponent_hand = opponent.hand.size
          opponent.current_choice.choose! nil
          expect(player.hand.size).to eq(current_player_hand)
          expect(opponent.hand.size).to eq(current_opponent_hand)
        end
      end
    end

    context 'and the opponent chooses to pay 5 gold' do
      it 'should pay the player 5 from opponent hoard' do
        current_opponent_hoard = opponent.hoard.value
        current_player_hoard = player.hoard.value
        opponent.current_choice.choose! 1 # choose to pay
        expect(opponent.hoard.value).to eq(current_opponent_hoard - 5)
        expect(player.hoard.value).to eq(current_player_hoard + 5)
      end
    end
  end
end
