RSpec.describe ThreeDragonAnte::Card::GreenDragon do
  let(:stacked_deck) do [
    *Factory.ante_to_choose_leader(:aleph),
    *Factory.flights(flights: {
      aleph: [{ type: ThreeDragonAnte::Card::GreenDragon, strength: proc { _1 > 5 } }],
      bet: [],
      gimel: []
    })
  ] end
  let(:game) { Factory.game(setup_until: [:gambit, 1, :round, 1, :aleph], stacked_deck: stacked_deck) }
  let(:gambit) { game.current_gambit }

  context 'when triggered' do
    let(:opponent) { game.players[1] }
    let(:player) { game.players[0] }

    before(:each) do
      player.current_choice.choose! 0 # play GreenDragon
    end

    it 'offers a choice to opponent to the left' do
      expect(opponent.current_choice.prompt).to eq :choose_one
      expect(opponent.current_choice.choices.size).to eq 2
    end

    context 'on a strength-1' do
      let(:stacked_deck) do [
        *Factory.ante_to_choose_leader(:aleph),
        { type: ThreeDragonAnte::Card::GreenDragon, strength: 1 }
      ] end

      it 'offers no choice' do
        expect(opponent.current_choice).to be_nil
      end
    end

    context 'and the opponent chooses to give a weaker evil dragon' do
      before(:each) do
        opponent.current_choice.choose! :give_weaker_evil_dragon
      end

      it 'should offer a choice of weaker evil dragons' do
        expect(opponent.current_choice.prompt).to eq :choose_to_give
      end

      context 'and has a weaker evil dragon' do
        let(:stacked_deck) do [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            aleph: [{ type: ThreeDragonAnte::Card::GreenDragon, strength: proc { _1 > 5 } }],
            bet: [{ type: ThreeDragonAnte::Card::BlackDragon, strength: proc { _1 < 5 } }],
            gimel: []
          })
        ] end

        it 'should successfully give a weaker evil dragon' do
          current_player_hand = player.hand.size
          current_opponent_hand = opponent.hand.size
          opponent.current_choice.choose!(0)
          expect(player.hand.size).to eq(current_player_hand + 1)
          expect(opponent.hand.size).to eq(current_opponent_hand - 1)
        end
      end

      context 'and does not have a weaker evil dragon' do
        let(:stacked_deck) do [
          *Factory.ante_to_choose_leader(:aleph),
          *Factory.flights(flights: {
            aleph: [{ type: ThreeDragonAnte::Card::GreenDragon, strength: 6 }],
            bet: [*5.times.map {{ strength: proc { _1 > 6 } }}],
            gimel: []
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
        opponent.current_choice.choose! :pay_me_5_gold
        expect(opponent.hoard.value).to eq(current_opponent_hoard - 5)
        expect(player.hoard.value).to eq(current_player_hoard + 5)
      end
    end
  end
end
